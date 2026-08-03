class Noodle < Formula
  desc "Terminal REST client"
  homepage "https://noodlerest.dev/"
  url "https://github.com/wilfredinni/noodle/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "4d7db7cc24b16a18bc68afab835002101151a898da4266f682195a1143938832"
  license "Apache-2.0"
  head "https://github.com/wilfredinni/noodle.git", branch: "main"

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  def install
    # --ignore-scripts skips husky postinstall (fails on extracted tarball, not a git repo)
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"

    # Build the standalone binary (bun build --compile embeds the Bun runtime)
    system "bun", "run", "build:bin"
    libexec.install "noodle"
    bin.write_exec_script libexec/"noodle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noodle --version")

    help_output = shell_output("#{bin}/noodle --help")
    assert_match "Terminal REST client", help_output
    assert_match "collection", help_output

    (testpath/"test_collection/ping.yml").write <<~EOS
      name: Ping Test
      method: GET
      url: https://httpbin.org/get
    EOS

    list_output = shell_output("#{bin}/noodle collection list --collection #{testpath}/test_collection")
    assert_match "GET Ping Test", list_output

    audit_output = shell_output("#{bin}/noodle collection audit --collection #{testpath}/test_collection")
    assert_match "Collection is valid", audit_output
  end
end
