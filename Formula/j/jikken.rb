class Jikken < Formula
  desc "Powerful, source control friendly REST API testing toolkit"
  homepage "https://jikken.io/"
  url "https://github.com/jikkenio/jikken/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "049691f48f13f8b155803df82eb99eb511503b7388d98d74d0db29b73126efd1"
  license "MIT"
  head "https://github.com/jikkenio/jikken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20ae33ce88425e104939812c56f2619cbda2570431a44e87b4a0e42028997ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b71504d1a5eb8d1509a04a8edfcb98db973fe1fd27d30b69649eb336067414ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d622380e17454f705b66505fd95eb06da9db61087ebd214c629897ae5747855b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ba12e70622eb28d3e238caf01757a4d135974aac22afa93cdf179674782fd5d"
    sha256 cellar: :any_skip_relocation, ventura:       "f67f299b1636e64c251bf71ee05b8cf669e5f63ae9639ffb7a0bc78422350c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e16712754cad5e86d225ea36efb22b9275f31f46083a426ae4ba4d4b5c03455d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/jk new test")
    assert_match "Successfully created test (`test.jkt`).", output
    assert_match "status: 200", (testpath/"test.jkt").read

    assert_match version.to_s, shell_output("#{bin}/jk --version")
  end
end
