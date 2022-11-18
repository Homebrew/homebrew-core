class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.19.1.tar.gz"
  sha256 "f5a20f2dc98fdebd5d42a45365f52fa59a7e6b174e43970fea4f9718a914e887"
  license "Apache-2.0"
  head "https://github.com/google/jsonnet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "704a65b23af2d1c139d1b2d581d5acc13125b50ca58265e8773323ab31654fe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b161392e3285d2de4b7592ec7ea47d56883e6eece220149ec3758f7b115825ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0694cd5affd28818bc88d9e2f03c26ff0cb0ffbbbf35c402210578d21ea24391"
    sha256 cellar: :any_skip_relocation, ventura:        "d5c9c758705412138f942212479cc22c54a5315e59e7f92be461817f33c0e532"
    sha256 cellar: :any_skip_relocation, monterey:       "601c60de61880b5ac463510587a2024e5a6123a221134e49f57a12b03e56fd56"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8531c4fd6ecf049c0a74fbab94640835d180685a5b462254f3c4b7c56d1d645"
    sha256 cellar: :any_skip_relocation, catalina:       "73595e462af29703e99c216c66e6e7a19d3e3421b5179e4100f989f1f1e865ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aaa84a604abec03db8e28c7c9b0f6dc47c4b3c7f7873cb9908838325d0ec05f"
  end

  conflicts_with "go-jsonnet", because: "both install binaries with the same name"

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
    bin.install "jsonnetfmt"
  end

  test do
    (testpath/"example.jsonnet").write <<~EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
