class Gomodifytags < Formula
  desc "Go tool to modify struct field tags"
  homepage "https://github.com/fatih/gomodifytags"
  url "https://github.com/fatih/gomodifytags/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "276526aede6e42c3d540cdaa5fe67cbd276837acfea5d9f5ca19c3a8d16a82ed"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62fe1ce46fb51e4c61c727e21a21df9a30830909e5b6aaa1e41e19a7c45d29d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "341e1cc756e6e89198f22e45b000dd0503cd615ddb007a00330f5b52b8950633"
    sha256 cellar: :any_skip_relocation, catalina:      "341e1cc756e6e89198f22e45b000dd0503cd615ddb007a00330f5b52b8950633"
    sha256 cellar: :any_skip_relocation, mojave:        "341e1cc756e6e89198f22e45b000dd0503cd615ddb007a00330f5b52b8950633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e2e993f70344fb828c1b5a212fca9f47366cacf6b9097a0d08dcdeeb3583257"
  end

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
