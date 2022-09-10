class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.0.2.tar.gz"
  sha256 "2a18c18752f8ca1acb1f955beef89ed7cedd7b4eabde32e65c27ffe3d52cc370"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cad48553dc48816d3812b18910f754e57b96a795c3b1ad1c4f1b53f74d516154"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13875794cd4ab7069996324fc7dce75b02764feaa75fb4e32825f8932ba3879e"
    sha256 cellar: :any_skip_relocation, monterey:       "6e9b48dfcdf9def9302ad641773694b30e810ffa2201f0ae084421cd3f065e5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a57e4b1b5208889ab85ccb2773edddf01aa8db7a42881513242d779a0418530c"
    sha256 cellar: :any_skip_relocation, catalina:       "4961f73a4a253901b715d8c4d4259275284f4c0b95dca03c8ee0d7e8ec3c5978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfbc0d0518344ea62a078994b69aaeba673fc529727d0215cb90cab4b93b307f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
