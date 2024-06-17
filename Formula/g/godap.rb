class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "c602f51337683a918b0d9014aa909119c213fe679ac2730991fc5b06f6be440a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cf6d9b8adb54473137280a7962d8e63e68227c38191bda29c1e6aa566ee9f86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65be0f9a3b4cf9ce2f638e005f2a1a0aeb51a17a0cfafa16496def0ff45688ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15cee9eccac5d72ad3892f5aa5ca64294243ce907b63d8b29e1929eec453519c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dff74cc329a7827ce61c58f52129b0efb5177c6c53e4d5d838dfbc2ebfd136a4"
    sha256 cellar: :any_skip_relocation, ventura:        "e8d9d43787ae07011a37baedab0643826248b2b517ade3a7b34f780f89661db7"
    sha256 cellar: :any_skip_relocation, monterey:       "b53086439ed5dd40f4240e2467ad664db61b4a3fee4ecfe954b1154a2a0040f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2014e9ba7671a42c5707eff24a3de1eb7130b4bc2acb9dce4e0ce352af6b7e7a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap",  "completion")
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: i/o timeout", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end
