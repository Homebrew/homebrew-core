class Baguette < Formula
  desc "Headless iOS Simulator manager and host-side input injection for iOS 26"
  homepage "https://tddworks.github.io/baguette/"
  url "https://github.com/tddworks/baguette/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "6d072ac72b9d473c9572e6390ff4bd441ec0d8da2e8b4eb55394bdd3c8cfaccf"
  license "Apache-2.0"
  head "https://github.com/tddworks/baguette.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1f177827e738d2164b7ca82841a016b93424a85ce985b8575eeb67c2a42eee26"
    sha256 cellar: :any, arm64_tahoe:       "15d1f4a603f1e9c1e64f0a9db5d71a5d6ae65dd95d2dbc5b7f5919ff104f55c0"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe

  # `swift build` fetches packages
  allow_network_access! :build

  def install
    # replace version like upstreams release process
    inreplace "Sources/Baguette/App/Version.swift",
              "let baguetteVersion = \"0.1.61\"",
              %Q(let baguetteVersion = "#{version}")

    # Rebuild the iOS-Simulator injection dylibs from source: upstream ships them prebuilt and universal,
    # which `brew audit` rejects. Mirrors each Injected/*/build.sh, for this arch only.
    # `-target *-simulator` stamps the iOS-Simulator platform load command, and `-headerpad_max_install_names`
    # leaves room for the Cellar-path ID Homebrew writes during relocation. Homebrew re-signing over
    # `-adhoc_codesign` is fine: baguette copies the dylib to a content-hashed path before injecting it.
    arch = Hardware::CPU.arch.to_s
    sdk = Utils.safe_popen_read("xcrun", "--sdk", "iphonesimulator", "--show-sdk-path").chomp
    dylibs = {
      "VirtualCamera"  => %w[Foundation UIKit QuartzCore CoreGraphics AVFoundation CoreMedia CoreVideo
                             ImageIO CoreServices],
      "VirtualMotion"  => %w[Foundation CoreMotion],
      "VirtualNetwork" => %w[Foundation],
    }
    dylibs.each do |name, frameworks|
      dylib = "Sources/Baguette/Resources/#{name}/#{name}.dylib"
      rm dylib

      clang_args = %W[
        -arch #{arch} -isysroot #{sdk}
        -target #{arch}-apple-ios17.0-simulator
        -dynamiclib -fobjc-arc -ldl
        -I Injected/#{name}/Sources -o #{dylib}
        -install_name @rpath/#{name}.dylib
        -Wl,-headerpad_max_install_names
        -Wl,-adhoc_codesign
      ]
      clang_args += frameworks.flat_map { |framework| ["-framework", framework] }
      clang_args += Dir["Injected/#{name}/Sources/*.m"]

      system "xcrun", "clang", *clang_args
    end

    system "swift", "build", *std_swift_args

    # Binary and its SPM resource bundle must sit side-by-side at runtime —
    # WebRoot resolves the bundle via dladdr from the executable's directory.
    # Install both into libexec and symlink the binary into bin.
    libexec.install ".build/release/Baguette" => "baguette"
    libexec.install ".build/release/Baguette_Baguette.bundle"
    bin.install_symlink libexec/"baguette"

    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baguette --version")

    # The top-level help lists the simulator-control subcommands, confirming
    # the binary and its argument parser initialize without a booted device.
    assert_match "Headless iOS simulator control", shell_output("#{bin}/baguette --help")

    # Unknown subcommands are rejected with a usage error (exit code 64),
    # exercising real argument parsing offline with no booted simulator.
    assert_match "Usage: baguette", shell_output("#{bin}/baguette no-such-command 2>&1", 64)
  end
end
