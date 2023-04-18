class Cwlogs < Formula
  desc "CLI tool for reading logs from Cloudwatch Logs"
  homepage "https://github.com/segmentio/cwlogs"
  url "https://github.com/segmentio/cwlogs/archive/v1.2.0.tar.gz"
  sha256 "3f7b56b49c42c1de0e697fc391abad07b03434cff36b153249dd2af3107e064e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8af6a596d63797973d316cd0d6b8151f939209506242af66fbab37b7a12c2c3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8af6a596d63797973d316cd0d6b8151f939209506242af66fbab37b7a12c2c3c"
    sha256 cellar: :any_skip_relocation, monterey:       "8768f31395820e0c298fd54ba9889e157c8107bfa0d094fa77bf84de660c9d9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "40fdfc79d6533963798aed789fe8026f30d44e87c3e6e9ecd602d531ed1fb7c2"
    sha256 cellar: :any_skip_relocation, catalina:       "975da66abe1ce9ff42eb63453c52acc31aeeffff435a2c0aab9d1bd3008be280"
    sha256 cellar: :any_skip_relocation, mojave:         "d0e1bda71db260a905c5f88da3fce0074ab59576ef6c12948eeae2ae5faf6435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30b6f2f4d84caf8e71cfb50c710030af0321585ef3de7ba3e3055381f16b7a6e"
  end

  # https://github.com/segmentio/cwlogs/issues/37
  disable! date: "2022-07-31", because: :unmaintained

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV["GO111MODULE"] = "auto"

    path = buildpath/"src/github.com/segmentio/cwlogs"
    path.install Dir["{*,.git}"]

    cd "src/github.com/segmentio/cwlogs" do
      system "govendor", "sync"
      system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
    end
  end

  test do
    output = shell_output("#{bin}/cwlogs help")
    assert_match "cloudwatch logs", output
  end
end
