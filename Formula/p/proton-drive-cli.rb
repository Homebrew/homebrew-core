class ProtonDriveCli < Formula
  desc "Command-line interface for Proton Drive"
  homepage "https://proton.me/support/drive-cli"
  url "https://github.com/ProtonDriveApps/sdk/archive/refs/tags/cli/v0.6.0.tar.gz"
  sha256 "52d0633dc2bbdee2c52fc3fef4a6b3680295972ad9bf06f5c004e511c7da06e7"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
    strategy :git
  end

  depends_on "bun" => :build

  # Bun runtime on linux dynamically links ICU (macOS uses libicucore)
  on_linux do
    depends_on "icu4c@78"
  end

  def install
    ENV["CLI_VERSION"] = version.to_s
    ENV["JS_VERSION"] = JSON.parse((buildpath/"client/js/package.json").read)["version"]
    # Identify Homebrew builds to Proton's API, per upstream guidance in cli/README.md.
    ENV["CLI_APP_VERSION_NAME"] = "cli-drive-homebrew"

    # The CLI bundles the Drive SDK from source, so install each workspace
    # package's dependencies before compiling the standalone binary.
    %w[client/js incubating/account/js].each do |dir|
      cd(dir) { system "bun", "install", "--frozen-lockfile", "--ignore-scripts" }
    end

    cd "cli" do
      system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
      system "bun", "run", "build"
      bin.install "release/proton-drive"
    end

    # Work around patchelf corrupting the bun-compiled binary during bottling
    # and causing a segfault; gzip it so relocation skips it (restored on install).
    if OS.linux? && build.bottle?
      prefix.install bin/"proton-drive"
      Utils::Gzip.compress(prefix/"proton-drive")
      (bin/"proton-drive").write <<~SHELL
        #!/bin/bash
        echo 'ERROR: Need to run `brew postinstall #{name}`' >&2
        exit 1
      SHELL
    end
  end

  def post_install
    if (prefix/"proton-drive.gz").exist?
      system "gunzip", prefix/"proton-drive.gz"
      (prefix/"proton-drive").chmod 0755
      bin.install prefix/"proton-drive"
    end
  end

  test do
    ENV["PROTON_DRIVE_CACHE_DIR"] = "#{testpath}/cache"
    ENV["PROTON_DRIVE_CREDENTIALS_STORE"] = "unsafe_file"

    assert_match version.to_s, shell_output("#{bin}/proton-drive version")

    # Operations require an authenticated session; check the CLI reaches that gate.
    output = shell_output("#{bin}/proton-drive filesystem list /my-files 2>&1", 1)
    assert_match "You need to login first", output
  end
end
