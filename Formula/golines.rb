class Golines < Formula
  desc "Golang formatter that fixes long lines"
  homepage "https://github.com/segmentio/golines"
  url "https://github.com/segmentio/golines/archive/v0.11.0.tar.gz"
  sha256 "d7336fbddb045bd2448629c4b8ef5ab2dc6136e71a795b6fdd596066bc00adc0"
  license "MIT"

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"given.go").write <<~EOS
      package main

      var strings = []string{"foo", "bar", "baz"}
    EOS
    (testpath/"expected.go").write <<~EOS
      package main

      var strings = []string{\n\t"foo",\n\t"bar",\n\t"baz",\n}
    EOS
    assert_match shell_output("#{bin}/golines --max-len=30 given.go"), (testpath/"expected.go").read
  end
end
