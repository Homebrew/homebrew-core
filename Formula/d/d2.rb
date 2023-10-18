class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c76e822755a64e2a6902d1f75a17bcda779c46cb36edc751b3eaa8d6f168b243"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9382456ffbd86fcbd3478cbc268dfe59ee1563564b02bb5f0a54320c596f2bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0fe2b8e47218ddc91662d1d60c2975c750457501590a0af6c8d77123cb9c746"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5fd79a185e1846ce9735155883c025f420304b5e0bc6139ca5c673c7ca2bfad"
    sha256 cellar: :any_skip_relocation, sonoma:         "e11efab3a9c774f0786f3100d4fe37ec867fd46d627235c384097d90bc0a558e"
    sha256 cellar: :any_skip_relocation, ventura:        "a3f28e72a01eeba92b2fc1892065cb70de4f5d77f0e2e02c88537f5e4644fb51"
    sha256 cellar: :any_skip_relocation, monterey:       "abdd1ab0357b1fd0d639694ef3d17257663ca457ae7595db3f0c19c79f66dc5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d435963a9b1ec4035904bf588c3d0abf7fd090429d454ec05def539692c753"
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

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
