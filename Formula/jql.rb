class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.1.4.tar.gz"
  sha256 "a640b41cb04a7bedf098b86859c8295277cec0e6f295bd5688a1cf94de5c4774"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc2eac6c0887b98410211fc4417a49d1bc7041137e88b50055b18c91a37270e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a00d24d2eb9a0de4596429c2fe2370e488dd60cb598d9b6d129d38298cf9e68b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0f072d4afb26e99dc873093ca96d39591ef253854579a8f3e3ed380e4933aed"
    sha256 cellar: :any_skip_relocation, ventura:        "4c63c455040737798214035db740b1390162c541c29dbf92054b63de1499aea8"
    sha256 cellar: :any_skip_relocation, monterey:       "b6955b0cb16afb621b84599ee7dbde8714684bc6e0a82de60a0876ac205a4c41"
    sha256 cellar: :any_skip_relocation, big_sur:        "54473c7f9570dad071388ddc3292946f71eed23a50617cbec5fea0249342ba51"
    sha256 cellar: :any_skip_relocation, catalina:       "a4809933d2791c437979fa9766ca28b738ee8d7ac73e9dc84d4490ec0f4208ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c23d6de594fb56e6d45c470270ac82a56ff228e557d1499338c9876c0d6a700b"
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
