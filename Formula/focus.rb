class Focus < Formula
  desc "CLI implementation of the Pomodoro technique."
  homepage "https://github.com/lfaoro/focus"
  url "https://github.com/lfaoro/focus/archive/v1.0.tar.gz"
  sha256 "ecfa00683bc47eebd6f8603a442c3d1017170ec9b5721de19e682612b27bb52a"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    focus_path = buildpath/"src/github.com/lfaoro/focus/"
    focus_path.install Dir["{*,.git}"]
    cd "src/github.com/lfaoro/focus/" do
      system "go", "build", "-o", bin/"focus", "-v"
    end
  end

  test do
    system "#{bin}/focus", "-v"
  end
end
