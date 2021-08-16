class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/v0.15.0.tar.gz"
  sha256 "e8be9e2fd8a6382cadebd9fda452b3580f16118a30f4d972acd2dea5baf3dcd8"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26a7909e40e2232d572a4b41fccb6671bc3a1fd3fa2e8633f6e945cae9c2f538"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ee56ae00501b7b75ddd7d81fd55bf49e7bf46d68a4317d9cd96a665bc07e8e5"
    sha256 cellar: :any_skip_relocation, catalina:      "670a6387e3c38e647ba11cc6cf28cfb3b941839058da995193731b10d76ea997"
    sha256 cellar: :any_skip_relocation, mojave:        "afb7b74aaf3668902f6b3e1023503ac39a190269c0ab6267a4f81f4316a979d0"
  end

  depends_on "rustup-init" => :build # clarinet needs nightly channel for this release

  # Nightly rust toolchain will be changed to stable on next release.
  # See https://github.com/hirosystems/clarinet/blob/main/Dockerfile#L7
  def install
    # This will install a nightly rust toolchain to be used with clarinet.
    system Formula["rustup-init"].bin/"rustup-init", "-qy", "--no-modify-path",
           "--default-toolchain", "nightly-2021-08-05", "--profile", "minimal"
    with_env(PATH: "#{HOMEBREW_CACHE}/cargo_cache/bin:#{ENV["PATH"]}") do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    system bin/"clarinet", "new", "test-project"
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
