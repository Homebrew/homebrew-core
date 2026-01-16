class Authz0 < Formula
  desc "Automated authorization test tool"
  homepage "https://authz0.hahwul.com/"
  url "https://github.com/hahwul/authz0/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "b62d61846f3c1559dbffb6707f943ad6c4a5d4d519119b3c21954b8cd2a11a16"
  license "MIT"
  head "https://github.com/hahwul/authz0.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fe2da611b2c22d82a4279dc10401a4046c94da994c296f87e4cb30c6f1556d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe2da611b2c22d82a4279dc10401a4046c94da994c296f87e4cb30c6f1556d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fe2da611b2c22d82a4279dc10401a4046c94da994c296f87e4cb30c6f1556d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cc9c71a90cc770c96bd24a6946a23759912d1dd52bc0b0953732a33064c208a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e60ac9cf6e9d8901bf7ad5f70e96757abd79f6b6121ad1945135f6043cd010e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b62fb4bf2c7ac8e013fbff4d57cbb6ab2ea703e16be23f0415dc0d02bd7c83"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"authz0", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/authz0 new --name brewtest 2>&1")
    assert_match "[INFO] [authz0.yaml]", output
    assert_match "name: brewtest", (testpath/"authz0.yaml").read

    assert_match version.to_s, shell_output("#{bin}/authz0 version")
  end
end
