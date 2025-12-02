class Authz0 < Formula
  desc "Automated authorization test tool"
  homepage "https://authz0.hahwul.com/"
  url "https://github.com/hahwul/authz0/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "b62d61846f3c1559dbffb6707f943ad6c4a5d4d519119b3c21954b8cd2a11a16"
  license "MIT"
  head "https://github.com/hahwul/authz0.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "07856f2310d354f1c7d363a2a7d1cfd3a1f1c5ca906934b57f33055b6c5633f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "76f92010b14aae9dae0ead727ef643ce0b0edc8a5361530ffdfd549b9895e2ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14381da4ed533631835222d21cd916381953a087c3b1335bb4d30a8c26acd382"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2a469a36c22f19b0ecc5ee81c8aae79cdd1f826a6ee917865666b7f004ab3a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68a16964db28dc0169285a3a7dc06c19544ec0f53fcc83396d7944700aea3826"
    sha256 cellar: :any_skip_relocation, sonoma:         "463ee39916da6ebe2df30fbf14805ea507a3c9be4881c5be47c8f538c34553d4"
    sha256 cellar: :any_skip_relocation, ventura:        "97e19733f1cab9bece649e12ef4ea454f05cb9596755d90901c74e7ebedcc56f"
    sha256 cellar: :any_skip_relocation, monterey:       "a3342b3b6def76d71b61f2a3c16cb9ce3ffed34787effd744d29de1a1277ebd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "98a9bcfcd1fd8a2b5572144d3beb098e37b61fef453fdc06426a7fe4a29c5331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c7d5364e993143029a3c66471ee76f88ed3f5e20e0094ba6aa497830b195fc6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"authz0", "completion")
  end

  test do
    output = shell_output("#{bin}/authz0 new --name brewtest 2>&1")
    assert_match "[INFO] [authz0.yaml]", output
    assert_match "name: brewtest", (testpath/"authz0.yaml").read

    assert_match version.to_s, shell_output("#{bin}/authz0 version")
  end
end
