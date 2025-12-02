class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "7ac2ee7b66d1c28d95af4a2da6cd2634c87c93470c028e40856e391d4d3232d4"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65125f26ee74c0d21b7c491fff3191256f020114180d5c3fcbdea12194b93ca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "121b9e1af6005f0692070dd80bb36b2043ee887b8c20ea41841fdce5436d1586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e9e1fc9e24d11dd57bf19510908531270ea5170f61a23e7c2bbc137d56fb1b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e657b243fd634dba710e5e5a4cf70bd078210f012583466700f032bedc741c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf0ef7101aa44a63dddf16e3073ab3f87f77fe4c667424e1a04cd52f17bf0a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b50c69d114e3557fe7e18040a069d654a1e36ce5de741a4f1833ca935690dab"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
