class Gomodifytags < Formula
  desc "Go tool to modify struct field tags"
  homepage "https://github.com/fatih/gomodifytags"
  url "https://github.com/fatih/gomodifytags/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "6180e1416733886df2cfcd342796353c8d0560cd311f7fe519d24c3b323f0977"
  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      type Server struct {
      	Name        string
      	Port        int
      	EnableLogs  bool
      	BaseDomain  string
      	Credentials struct {
      		Username string
      		Password string
      	}
      }
    EOS
    expected = <<~EOS
      package main

      type Server struct {
      	Name        string `json:"name"`
      	Port        int    `json:"port"`
      	EnableLogs  bool   `json:"enable_logs"`
      	BaseDomain  string `json:"base_domain"`
      	Credentials struct {
      		Username string `json:"username"`
      		Password string `json:"password"`
      	} `json:"credentials"`
      }

    EOS
    assert_equal expected, shell_output("#{bin}/gomodifytags -file test.go -struct Server -add-tags json")
  end
end
