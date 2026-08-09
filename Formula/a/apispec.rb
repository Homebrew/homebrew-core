class Apispec < Formula
  desc "Generate OpenAPI 3.1 specs from Go source by static analysis"
  homepage "https://apispec.ehabterra.com"
  url "https://github.com/ehabterra/apispec/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "8f911576f3284988af11708fcb7c6e3a6e4742a1e39e32b27bdc181aec05da61"
  license "Apache-2.0"
  head "https://github.com/ehabterra/apispec.git", branch: "main"

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/apispec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apispec --version")

    (testpath/"go.mod").write "module example.com/t\n\ngo 1.21\n"
    (testpath/"main.go").write <<~GO
      package main

      import "net/http"

      func main() {
        http.HandleFunc("/things", func(w http.ResponseWriter, r *http.Request) {})
        _ = http.ListenAndServe(":8080", nil)
      }
    GO
    system bin/"apispec", "--dir", testpath, "--output", testpath/"openapi.yaml"
    assert_match "/things", (testpath/"openapi.yaml").read
  end
end
