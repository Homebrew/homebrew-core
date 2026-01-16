class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "7feac1bebb04eead4c5c054e35ed925a3029904e783fc579a7a6d5e29fe01426"
  license "MIT"
  head "https://github.com/edoardottt/favirecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24148b45f6af8b3bf04d326f518bb13f21ca8451e7e8bb7b136620211b542d88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24148b45f6af8b3bf04d326f518bb13f21ca8451e7e8bb7b136620211b542d88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24148b45f6af8b3bf04d326f518bb13f21ca8451e7e8bb7b136620211b542d88"
    sha256 cellar: :any_skip_relocation, sonoma:        "a56331bc32be1117c2a49575b6370f5e42b52792bd4052d5740f6aebee0c77ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7f5e22feed110507aeaf85688294ca108621b86a2eff5dbc469c48edc145458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f34ea1eb51f6fee500858b616af0e49a8e00e52a19979c22ecfacb69cc0e22d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/favirecon --help")

    output = shell_output("#{bin}/favirecon -u https://www.github.com -verbose 2>&1")
    assert_match "Checking favicon for https://www.github.com/favicon.ico", output
  end
end
