class GitCredentialManager < Formula
  desc "Secure, cross-platform Git credential storage for GitHub, Azure Repos, and more"
  homepage "https://github.com/git-ecosystem/git-credential-manager"
  url "https://github.com/git-ecosystem/git-credential-manager/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "a9c1d7a89c620bea0df65623f25c62e66122d22557583ab390ed612d544884e9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1] }
    end
  end

  depends_on "dotnet" => :build
  depends_on "patchelf" => :build
  depends_on "icu4c@78"
  depends_on :linux

  def install
    runtime = Hardware::CPU.arm? ? "linux-arm64" : "linux-x64"
    gcm_version = (buildpath/"VERSION").read.chomp

    system "./src/linux/Packaging.Linux/build.sh",
      "--configuration=Release",
      "--version=#{gcm_version}",
      "--runtime=#{runtime}",
      "--install-from-source=false"

    tarball = Dir["out/linux/Packaging.Linux/Release/tar/gcm-#{runtime}-[0-9]*.tar.gz"]
              .reject { |f| f.include?("symbols") }.first
    raise "Build tarball not found" unless tarball

    libexec.mkpath
    system "tar", "-xzf", tarball, "-C", libexec

    # Bake RPATH into the binary so bundled native libs (libHarfBuzzSharp,
    # libSkiaSharp) and icu4c are found without leaking LD_LIBRARY_PATH to
    # child processes (which would be a security risk for a credential helper).
    rpath = "#{libexec}:#{Formula["icu4c@78"].opt_lib}"
    system "patchelf", "--set-rpath", rpath, libexec/"git-credential-manager"

    bin.install_symlink libexec/"git-credential-manager"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-credential-manager --version")
    config = testpath/".gitconfig"
    config.write ""
    ENV["GIT_CONFIG_GLOBAL"] = config.to_s
    system bin/"git-credential-manager", "configure"
    assert_match "manager", shell_output("git config --global credential.helper")
  end
end
