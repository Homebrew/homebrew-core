class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "d44259fb90b4687284200cbccedf7a55c273ffd162583fdc366f9e77506622ad"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92a4efbcd3ec793ed21bd1f9e33019029caf7ac452e9c44ec0ced748bb365a71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92a4efbcd3ec793ed21bd1f9e33019029caf7ac452e9c44ec0ced748bb365a71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a4efbcd3ec793ed21bd1f9e33019029caf7ac452e9c44ec0ced748bb365a71"
    sha256 cellar: :any_skip_relocation, sonoma:        "e85119e9b008426686b8a25be3b16860afad0f9495f2b4262ea7528e258b310b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1256c9a1a83897e107d669d351675df8b32ced763fb505bca8bf3a7e0ec773f0"
    sha256 cellar: :any,                 x86_64_linux:  "a8d8f06d41e837ab12a606bf187ad2355bfb8b8901fea09c610daba5201bed9d"
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
