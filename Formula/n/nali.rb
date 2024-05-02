class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "8918e4c1c720dad1590a42fa04c5fea1ec862148127206e716daa16c1ce3561c"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76f8757159e2e3c2bfb3109af9f600c1e7f677350f60921bec3473fbf4bc3aa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89356d49ebdb86e18fca7e8926abfaa960cbd1a46f1b48338ebbc74ced01118b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb89af61ac162342c4ca2653bff21a9f8a75d63abc1dd86692bc041d24f23d8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7d393c430c3ca19676c066a8b3cb56326294b548d86640b5e2eb72a460760d8"
    sha256 cellar: :any_skip_relocation, ventura:        "3ef92c525d545264883712778c49e3c7484a4fb82b778fe1b4dbf05f32c8f710"
    sha256 cellar: :any_skip_relocation, monterey:       "35b1f99514e2f869460effc62db4c8d9bf2449a21eb30e4abfa26dd6a36e761a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a140b6b0fc32fa502fdc1edf5bac51e5c4d1cc3e8f6abe99abc55e80c69a1f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"nali", "completion")
  end

  test do
    ip = "1.1.1.1"
    # Default database used by program is in Chinese, while downloading an English one
    # requires an third-party account.
    # This example reads "Australia APNIC/CloudFlare Public DNS Server".
    assert_match "#{ip} [澳大利亚 APNIC/CloudFlare公共DNS服务器]", shell_output("#{bin}/nali #{ip}")
  end
end
