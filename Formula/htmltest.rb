class Htmltest < Formula
  desc "HTML validator written in Go"
  homepage "https://github.com/wjdp/htmltest"
  url "https://github.com/wjdp/htmltest/archive/v0.14.0.tar.gz"
  sha256 "add922cf1dd957afba2927d401184c1d2331983a6d8ed96dd10f5001930cebf8"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.date=#{Utils.safe_popen_read("date", "-u", "+%Y-%m-%dT%H:%M:%SZ")}
      -X main.version=#{version}
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <body>
          <nav>
          </nav>
          <article>
            <p>Some text</p>
          </article>
        </body>
      </html>
    EOS
    assert_match "htmltest started at", shell_output("#{bin}/htmltest test.html")
  end
end
