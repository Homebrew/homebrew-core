class Flamebearer < Formula
  desc "Blazing fast flame graph tool for V8 and Node"
  homepage "https://github.com/mapbox/flamebearer"
  url "https://registry.npmjs.org/flamebearer/-/flamebearer-2.2.0.tgz"
  sha256 "30464b792b16b27acee532045f8fa54dd4fbb319925b6989a1765ae52603530a"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e47f059d69e35fa11b6995c304ed1f3251bbc65d1f98e28265292c7eacfa307"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"app.js").write <<~JS
      let x = 0;
      for (let i = 0; i < 5e6; i++) x += Math.sqrt(i);
      console.log(x);
    JS
    system formula_opt_bin("node")/"node", "--cpu-prof", "--cpu-prof-dir=#{testpath}", testpath/"app.js"
    profile = testpath.glob("*.cpuprofile").first

    assert_match(/samples:\s+\d+/, shell_output("#{bin}/flamebearer #{profile}"))
  end
end
