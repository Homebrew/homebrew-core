class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.42.5.tar.gz"
  sha256 "b2574a8618663b3d26079da776533a1730b1687abab251a0d34348d63b0b74d4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e61d3b3950e9a1abcc71b82e2d39675108dc4855b4af7fc962aaa6b17f8630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e05cd5a740cb7b703ae5583cb0656281f1f952ad852b4794d4dd6cf3459a749c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "108d6c054cf0fb61cfca785bc03a677c73b174b5b551646986f8aadbf371243e"
    sha256 cellar: :any_skip_relocation, sonoma:        "237664c1deadf38a431e903021b1cdc16c6454c1d2b597c9331871461e8b0f61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "232911e395ba3749dd2c69e5fc69c712d9d38d3d5a791a84703001ec13ee3ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e3e009983ae6f16312a01d6074cd03fc4f24cf5d2db5edb5d85caa864d579ca"
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
