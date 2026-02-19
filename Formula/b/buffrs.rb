class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "656e47a82a467e43ff3b3e3420be1b0ddb6365283ec554c0f70e0926d634eb57"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4db6820defc461043f1373a50165f5eaba8210aef848836664002239620ca283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09d80927038a90ce3d6bf4f75f22bd586eab04cf95eaf6072ac1eb5ab4ae76d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05427b70eaab10b650cfa3e981729e55b5e95e573c719371e05f6371f0061936"
    sha256 cellar: :any_skip_relocation, sonoma:        "55dc45ead5d123644d6c069e8a7fc4cf5432edcf6aa819af8eee455691e17a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94331fda981f08d60b941ea0dfa324ea9bcee66dcb7d026db1ab3de8662f5341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9004d123f0bcf9188e670f8e723da3a981451605af415aa6779d4ae449141728"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end
