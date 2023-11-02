class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "b374f6f624eae664a53374c14879b1ffde7daa32ca37ae7f2c05dc3a114a5131"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50be5eec191f853c99733ace088b8564188c75e4ebde7503b9821a8d129cbbd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5056bae531f54a93f579be9d90c80bcdd881c2a94205bf6287a8b0dde3c8ba2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eedcf911f628144deab9bfb8e24d3957c1bb05965924f95792def57327e6deaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8ed1a2d41b1aa5528a89cdf3ab63f5c63fab502f0ba546eb0a26e191244c378"
    sha256 cellar: :any_skip_relocation, ventura:        "e6b355c7ec4329dad0ede14ba2037a0e6e59ca08c1573a1a669be9d22f8523e6"
    sha256 cellar: :any_skip_relocation, monterey:       "8c14f92858bc4531d88938d54bfa9a8b73ad1857b24392040dce3f22b0b1ba15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c4755fd7431e7e4df69bfc88d47bcd2383dc5703cbe863bb58176a827b4f0c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
