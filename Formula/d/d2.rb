class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "42a941c36dab75cc3ffa4dc29f50af89be5f76d252be1bca3d812271f63e30c7"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbd9bfe4a6edddd9a1f6560203f9b9f050994da561b88691d825ce7409ae02fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9deefb9dc0fa2e121ee0497396178df3f6976b255660669cb6ad3b142b7fce9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a16595d7bc7405f4ec1bfd91d172e18074f20406e617b6f33d26fd67e93f1a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c27af01eb9e753b4416d05411db85e99d822e3b1d4bc580f2a8990e0efa587f"
    sha256 cellar: :any_skip_relocation, ventura:        "3f8653d675ba960f9d03059e28a7cd75b3af2cc864ecf366a07538e51173c778"
    sha256 cellar: :any_skip_relocation, monterey:       "b483a052b8e2bfa4c1d709553aa382e8612d0044bd150bf49915deb7e96284b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e354446de2212c315be64ac9cbf9987017ff2186e70b7a4139884f31bb3f8f09"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
