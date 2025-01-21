class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "c2b431067b5f1baddd8d8a08f99a321ea66a6af4ecfcce65b044571f4f09faf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "067dd8fc65947b6384bff0a92a706de1455cd11236ac247f6c8e2122c9f66ed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "067dd8fc65947b6384bff0a92a706de1455cd11236ac247f6c8e2122c9f66ed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "067dd8fc65947b6384bff0a92a706de1455cd11236ac247f6c8e2122c9f66ed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c31f11bd059f923724d4a00c889e6ff651da748e4afb568a5dae439b687115b"
    sha256 cellar: :any_skip_relocation, ventura:       "6c31f11bd059f923724d4a00c889e6ff651da748e4afb568a5dae439b687115b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8680a9e922ed08185e0b8449cfeca60e0f0ed9df9a0916f0059f7b6ec6baf73"
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
