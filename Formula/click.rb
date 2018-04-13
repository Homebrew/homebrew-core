class Click < Formula
  desc "Command-Line Interactive Controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.3.2.tar.gz"
  sha256 "eed648409bf78a05658a9d097e5099ca17bf19df70122e2067859ae94c5575d5"
  head "https://github.com/databricks/click.git"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/click"
  end

  test do
    system "#{bin}/click"
  end
end
