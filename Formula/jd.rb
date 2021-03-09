class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.3.0.tar.gz"
  sha256 "cbd5f2ff3c56a57126acd246cbd7820dbc4a9296756c5af9ce4ca705bcefc0d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5b45be90cd17c04df3705c2ee08cdef96e46e74367d8203b0e5d78b03ac925e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "25a7769810ab7ae690b0eb36ca77ebabb2c1d7bccf69fc5d84997019c1ecce42"
    sha256 cellar: :any_skip_relocation, catalina:      "b2598d40731b157f9bad27e48397db6dd44f8df036f66657ea9961e6a04573a2"
    sha256 cellar: :any_skip_relocation, mojave:        "82b255b04f78303e4df2fb1d68c8d2d0ff852372516efe6a9d1b476db96d9166"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    output = shell_output("#{bin}/jd a.json b.json")
    assert_equal output, expected
  end
end
