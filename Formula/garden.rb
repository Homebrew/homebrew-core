class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://github.com/davvid/garden"
  url "https://github.com/davvid/garden/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "fa0c35e647310b04daf07ce7833a06d81ff4b16b64edb68f970a56a639477da0"
  license "MIT"
  head "https://github.com/davvid/garden.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"garden.yaml").write <<~EOS
      trees:
        current:
          path: .
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${name}
      variables:
        name: $ echo garden
    EOS
    system bin/"garden", "-vv", "test", "current"
    assert_predicate testpath/"garden", :exist?
    assert_predicate testpath/"current", :exist?
  end
end
