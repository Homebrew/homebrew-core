class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.10.4.tar.gz"
  sha256 "c0b8d4a8845566c7623a1615accd150df5c3c96769241b7c232e81348114a486"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a1d563287d626138860e7389d704220db87d7961f8db53bc3adcfbcc871caa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a1d563287d626138860e7389d704220db87d7961f8db53bc3adcfbcc871caa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a1d563287d626138860e7389d704220db87d7961f8db53bc3adcfbcc871caa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b5fa7e85b0118852ae7f9a71afdfe138e5696a02df28bfeb6cccb2efefed73c"
    sha256 cellar: :any_skip_relocation, ventura:       "0b5fa7e85b0118852ae7f9a71afdfe138e5696a02df28bfeb6cccb2efefed73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a6b6285b6c63d7e8486130df4d0c980b6c8e7fc32bb7a8a75ea1e6014e08802"
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
