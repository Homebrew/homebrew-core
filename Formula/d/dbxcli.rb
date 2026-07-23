class Dbxcli < Formula
  desc "Command-line tool for Dropbox users and team admins"
  homepage "https://github.com/dropbox/dbxcli"
  url "https://github.com/dropbox/dbxcli/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "7957e5558d8c7ee57f3a3e77828d4fabd3952afb88e28ee1de24687ccace9128"
  license "Apache-2.0"
  head "https://github.com/dropbox/dbxcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3be31264c39585fef789a8adc53046efe1b25a5a66c1f60b137f6df9d6940427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be31264c39585fef789a8adc53046efe1b25a5a66c1f60b137f6df9d6940427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be31264c39585fef789a8adc53046efe1b25a5a66c1f60b137f6df9d6940427"
    sha256 cellar: :any_skip_relocation, sonoma:        "22debb13cf44207fe3678b17a2d0d21484af885dcbd29e7bf6c37da980a41f2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d5ebabfa1c9d2847caf2ab5f90a58e60f09172457723d9e557f62f1734d2207"
    sha256 cellar: :any,                 x86_64_linux:  "eca784c9d61c58d7a79d5cc870c936f8ca033cab5e17cecac7ba238932f52e1b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dbxcli", "completion")
  end

  test do
    ENV["DBXCLI_AUTH_FILE"] = testpath/"missing-auth.json"
    output = shell_output("#{bin}/dbxcli ls 2>&1", 2)
    assert_match "no saved Dropbox credentials", output
  end
end
