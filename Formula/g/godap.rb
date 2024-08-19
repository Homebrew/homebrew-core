class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "997f7905f248bf29388dba3bc4d2bbb203dbc4ca16784afc1ef03d7bec316f8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff07ac7639b23ae013cf41fe727ddb35587f01541a2769d323a5344dd1f51c83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0ca5f9128379ac2ccc8901baba8945cbfb705bcaa0af39b44b0157dbbf5ea14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8f8f392f493bced3a001326d2672009fcd557e03cf83c1ea870dea2ba745cff"
    sha256 cellar: :any_skip_relocation, sonoma:         "457e1bdb24f042c43d93e0331ab9d858cfbca8a9a49f9f97bd98efbc9a499fee"
    sha256 cellar: :any_skip_relocation, ventura:        "9e0f74a589b1c16bd2f8cc9b767313ad6bf6ce50a39228e449ce61b744326296"
    sha256 cellar: :any_skip_relocation, monterey:       "07a1e11b55a72a459c67d981c239d1ca860893f1e1975c19641452a2fb96a50e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d6a86b998b90efa9fda106ef9bfd9930359099d5e213f3182dd461b321e8301"
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
