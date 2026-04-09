class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "8b36a883dd571fbdb39a66be6c79ffbf2f6c4a24adcf554a5da858af626f4559"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b887f7f362b09b785ab6a6dcf23497dfb59913e347a7e72f9bb014185678a0a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b887f7f362b09b785ab6a6dcf23497dfb59913e347a7e72f9bb014185678a0a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b887f7f362b09b785ab6a6dcf23497dfb59913e347a7e72f9bb014185678a0a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4d637e9c7422959bed7972c057cacff6777b05485936eeb9d8cdd6b8f78bb29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084972e71575bbccb3b62ff0891ba212bd8bbad3eb3e86c71549020c7b0a4e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9524d91e142bfbe3a3151b3bb2ea26691ba71242d8c2f130628a26bfd514b429"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap",  shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: i/o timeout", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end
