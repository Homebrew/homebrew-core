class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dc94c802937d54dc3646de92b7e39b837c8be116ec8a60c55d2f53ba0eab98d4"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98e7c2dfdf612ea2aaebfc52ff98b10a05f9b62017901755d333e5115ed48546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e033da8e80a2c8aa727418bc2c47c83ebb2793c7bf23582456e6f3e38eebdca6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "075d518384908583c04d9b841486b5bafa10e7ca5673eef492743c338943c621"
    sha256 cellar: :any_skip_relocation, ventura:        "0b59d5cf0cdd290c80a99194d0198a36db1946894d424df60616c1388ba3b750"
    sha256 cellar: :any_skip_relocation, monterey:       "a872d6bad4b362330c1cd20382ebc1b872045083f93514d5660d769815750dbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "28a089a8cbef7649e001c2aab870270202fb20b9272d9795df13b3e2a96a01de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ae963236c801c6eaa50c2512b8e8af19e0f2c3a26211d1249def31e7d1d69a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", test_file
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
