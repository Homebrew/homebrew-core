class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.1.tar.gz"
  sha256 "5192f471658ef1af38060ccd74d767bc7f1b60ba8de04335a6cccb88a1d28e20"

  bottle do
    cellar :any_skip_relocation
    sha256 "e096231d88fa92e9215345a34de8b5dceb5e3217a22681107f81b935b9090619" => :catalina
    sha256 "0a33823d7919a0218e895685903d718bc3013e13710166797cfa332895c6a4e1" => :mojave
    sha256 "fed5e72e199dd94ef0f34b506f689de867ac8f938641a9738e99dc8f4c27cbe6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/josephburnett/jd"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"jd"
      prefix.install_metafiles
    end
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
