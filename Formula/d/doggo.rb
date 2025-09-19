class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "92a34f5510a48ab657a980c39edf907c17e96e88a476187d5b57a8cef3becd5b"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d471b8706aef800238df8e97420f6a444e524d11dc6f74e6180f6e0092be812e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659e186849f180769977ef2af67b9880c454b72d32853222ab69f396e51094f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "659e186849f180769977ef2af67b9880c454b72d32853222ab69f396e51094f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "659e186849f180769977ef2af67b9880c454b72d32853222ab69f396e51094f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2bf2f469a3d501455d0c5db6005dd1f78a5a3916e31253361db0effd0d4cedf"
    sha256 cellar: :any_skip_relocation, ventura:       "e2bf2f469a3d501455d0c5db6005dd1f78a5a3916e31253361db0effd0d4cedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6ef549e7c62a7cd3f1cf41dd03e7f99bf26e256f950ddc1b6c08d2a488debd5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
