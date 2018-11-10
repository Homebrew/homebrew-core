class Awsweeper < Formula
  desc "Cleat out your AWS account with this convenient tool"
  homepage "https://github.com/cloudetc"
  url "https://github.com/cloudetc/awsweeper/archive/v0.2.0.tar.gz"
  sha256 "e867ecc3df01fb799fe900bc587676460ade1752f63c9176542bb66d27a1833a"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    awsweeper_path = buildpath/"src/github.com/cloudetc/awsweeper"
    awsweeper_path.install buildpath.children

    cd awsweeper_path do
      system "go", "build"
      bin.install "awsweeper"
    end
  end

  test do
    assert_match "0.1.1", shell_output("#{bin}/awsweeper --version ")
  end
end
