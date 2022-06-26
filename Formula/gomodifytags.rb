class Gomodifytags < Formula
  desc "Go tool to modify struct field tags"
  homepage "https://github.com/fatih/gomodifytags"
  url "https://github.com/fatih/gomodifytags/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "276526aede6e42c3d540cdaa5fe67cbd276837acfea5d9f5ca19c3a8d16a82ed"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f99010f77d3726d789cd1d870442fb867595fa62b5f1addc44f27840581c18a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbd3a4c7a66090a7c17afd699b0b35d70663b5e9305085a573a3493a5cc4ebe2"
    sha256 cellar: :any_skip_relocation, monterey:       "762d9e674caf68cff1c1ed195064ddb01b5705e45b079832cb2aa414ee38086a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3c815e6288c0c3474800937bbb15fa2569e34a7715121b94c713b8575c51203"
    sha256 cellar: :any_skip_relocation, catalina:       "c3c815e6288c0c3474800937bbb15fa2569e34a7715121b94c713b8575c51203"
    sha256 cellar: :any_skip_relocation, mojave:         "c3c815e6288c0c3474800937bbb15fa2569e34a7715121b94c713b8575c51203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0cdedf095c819f8b5293dbda500958d18ea93339d2cf4340973e3b3141d9317"
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
