class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v0.5.0.tar.gz"
  sha256 "17fc6c5c0f7bea8ce59e0bfb315198cc9f9ecfda98d51909149d42ffd125d72f"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tetratelabs/func-e/internal/version.funcE=#{version}
    ]
    system "go", "build", "-trimpath", "-ldflags", ldflags.join(" "), "-o", bin/"func-e"
  end

  test do
    system "#{bin}/func-e", "-v"
  end
end
