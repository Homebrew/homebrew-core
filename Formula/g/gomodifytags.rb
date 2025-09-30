class Gomodifytags < Formula
  desc "Go tool to modify struct field tags"
  homepage "https://github.com/fatih/gomodifytags"
  url "https://github.com/fatih/gomodifytags/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "a490786d80c962dc946b8f9804ffec596c1087dbf91b122b9b5903c03b6da6b9"
  license "BSD-3-Clause"
  head "https://github.com/fatih/gomodifytags.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2bb3e43ab010627c5f030b08b5dda260dac10c5035303c9188eccaf2e0ab0e04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b7474e31cc4b65ec1f641c57a371aa13754a0044cfd63f611f29e594e799ea7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b8b61d88b7f280dce019aca484de7be64234a31ba3b20192e35f3c58dc5e0ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b8b61d88b7f280dce019aca484de7be64234a31ba3b20192e35f3c58dc5e0ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b8b61d88b7f280dce019aca484de7be64234a31ba3b20192e35f3c58dc5e0ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "c45d10a4c19d9898dadbd7b98b07ebcd7f9cf1bcd14641db6d3d665226c4f163"
    sha256 cellar: :any_skip_relocation, ventura:        "c45d10a4c19d9898dadbd7b98b07ebcd7f9cf1bcd14641db6d3d665226c4f163"
    sha256 cellar: :any_skip_relocation, monterey:       "c45d10a4c19d9898dadbd7b98b07ebcd7f9cf1bcd14641db6d3d665226c4f163"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "59d33031dcc82467c4a778fb04b3cbae0f2ba73fccce73b0585fdff0fdb6fbaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0150f69a9b1e40bc73e41616c4b7cc0d4e515e8eba31756302899a5dd64203cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.go").write <<~GO
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
    GO
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
