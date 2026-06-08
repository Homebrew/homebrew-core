class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "a7ca204fec11a80eeca4d02f78c90d11b9ecc4f7e40e290ce112436979c66f71"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8119bb802beef388364f8452a16e1927c49b8e221dbd14cbd93159561a5bdef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8119bb802beef388364f8452a16e1927c49b8e221dbd14cbd93159561a5bdef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8119bb802beef388364f8452a16e1927c49b8e221dbd14cbd93159561a5bdef8"
    sha256 cellar: :any_skip_relocation, sonoma:        "60fff45bd36da2e38ea1e4df041d02907436d8538e075fbf6738084e43f6c08a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "126e9dd4af5f0e758157a773e0c467c60afdc9ba39d4bc6e7b63a810d894d065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb733ad20e36af93a8f438bfec87bc205727f83d5a71a13ca1c0685f6ef69eeb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion", shells: [:bash, :zsh, :fish, :pwsh])

    (man1/"dasel.1").write Utils.safe_popen_read(bin/"dasel", "man")
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
