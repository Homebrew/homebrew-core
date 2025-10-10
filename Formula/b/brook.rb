class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://brook.app/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20250808.tar.gz"
  sha256 "d78e8066ba5377c3841c8b6dcc6949cccbc04f3e475a3ac34587721438cde494"
  license "GPL-3.0-only"
  head "https://github.com/txthinking/brook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1242b02dbfd40053930fe0d52f7bb925b8c5fea7401e8e6e132d26086028793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564f95bb9ccd7cb726f77a7edbefa788366804c53d87398715a23a54cd1354d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "564f95bb9ccd7cb726f77a7edbefa788366804c53d87398715a23a54cd1354d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "564f95bb9ccd7cb726f77a7edbefa788366804c53d87398715a23a54cd1354d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "43906bd2683a7b8d2d8ebfc55771e74c1161d8cf25af6482e429335e248db075"
    sha256 cellar: :any_skip_relocation, ventura:       "43906bd2683a7b8d2d8ebfc55771e74c1161d8cf25af6482e429335e248db075"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04c6e67447718429922cd0dc6ea53c3e9b3b4c6ed3ea02bc63300070657aef8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "401093bfe7df589f3e79937615e8f7585e7d916b714cc4c56a3cef1641be514d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    # We expect something like "brook://server?password=hello&server=1.2.3.4%3A56789"
    uri = URI(output)
    assert_equal "brook", uri.scheme
    assert_equal "server", uri.host

    query = URI.decode_www_form(uri.query).to_h
    assert_equal "1.2.3.4:56789", query["server"]
    assert_equal "hello", query["password"]
  end
end
