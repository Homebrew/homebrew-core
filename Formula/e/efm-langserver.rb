class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.48.tar.gz"
  sha256 "39d56178a11c39f865eb2e3677d51af7ac62c79e0b6daa9176dcd8f58a4c0b05"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eed9a37c25ac1d8cb6e65af9d54adab0db45991e5e7cffc2a52d724bd12f9a3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34e9c2849538000efb03912f10eafe86359b8991760508b4859b920385f6a374"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34e9c2849538000efb03912f10eafe86359b8991760508b4859b920385f6a374"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34e9c2849538000efb03912f10eafe86359b8991760508b4859b920385f6a374"
    sha256 cellar: :any_skip_relocation, sonoma:         "c771af36639ee4fe1de34ad0cb0334d21d2c90d7a059dd8c5515354781ea4f16"
    sha256 cellar: :any_skip_relocation, ventura:        "d60ab1b882a1d5057e4dfd4f139d781a40cb84e535af5c6fc9893b45104362dc"
    sha256 cellar: :any_skip_relocation, monterey:       "d60ab1b882a1d5057e4dfd4f139d781a40cb84e535af5c6fc9893b45104362dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d60ab1b882a1d5057e4dfd4f139d781a40cb84e535af5c6fc9893b45104362dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0297f619f11165dd6c4ca392549d609b1ecbb2be390bdad613dc33b2c25c77f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"config.yml").write <<~EOS
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    EOS
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end
