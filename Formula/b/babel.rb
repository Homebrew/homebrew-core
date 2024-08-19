require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.25.2.tgz"
  sha256 "6873c15a448a1ad6cd7a5b845d20e2348e04abc1a2261354ad3c702689a4ad0a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dd5647d696698bb8a880823ddb5211d2a3fad7746e08c28623ca535a5052078"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dd5647d696698bb8a880823ddb5211d2a3fad7746e08c28623ca535a5052078"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd5647d696698bb8a880823ddb5211d2a3fad7746e08c28623ca535a5052078"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dd5647d696698bb8a880823ddb5211d2a3fad7746e08c28623ca535a5052078"
    sha256 cellar: :any_skip_relocation, ventura:        "6dd5647d696698bb8a880823ddb5211d2a3fad7746e08c28623ca535a5052078"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd5647d696698bb8a880823ddb5211d2a3fad7746e08c28623ca535a5052078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "093bd57c05ed3a658e43bbe8f83d3321c01f7a365d2e5e38f70325cafc23024f"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.24.8.tgz"
    sha256 "989e83a3bc6786ae13b6f7dee71c4cfc1c7abbbaa2afb915c3f8ef4041dc2434"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *std_npm_args(prefix: false), "--production"
    end

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
