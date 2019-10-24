class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.1.tar.gz"
  sha256 "5192f471658ef1af38060ccd74d767bc7f1b60ba8de04335a6cccb88a1d28e20"

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
