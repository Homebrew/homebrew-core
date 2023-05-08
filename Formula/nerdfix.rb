class Nerdfix < Formula
  desc "Find/fix obsolete Nerd Font icons"
  homepage "https://github.com/loichyan/nerdfix"
  url "https://github.com/loichyan/nerdfix/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "0a4587caaa2d9654ef41e48612267343c5f018387f3f36564688263114629cad"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a613c51836942a28196dc764d1bcb498351bed61e2e8af71c6e567b012fdece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51c5c3faa421beb2409afa6d51e8cdce3a96d0b89ada652a7ed2f9da5bcba3df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "713d7fa4eb9a2ae5c0a66418c188796f3d8e58df41a8c6052c6fcf85e94de4f0"
    sha256 cellar: :any_skip_relocation, ventura:        "82232c83a369f65b9e5dd9b8b1d464cfe731d763d747d8880d1db0bc0d009528"
    sha256 cellar: :any_skip_relocation, monterey:       "289ea9825db6376ede3bf7eebf2512f52ae591c7981bbb4819e22e5cfefa3d8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab57c453e3a881a958f8432f7a034a218cc71719c1ec83f4e8d451161fad0a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b34e0aa99804bda37bcf0c48c6467de1f2b09573316cf58e19e924111ad0923d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    system bin/"nerdfix", "check", "test.txt"
  end
end
