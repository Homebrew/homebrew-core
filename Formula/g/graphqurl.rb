class Graphqurl < Formula
  desc "Curl for GraphQL with autocomplete, subscriptions and GraphiQL"
  homepage "https://github.com/hasura/graphqurl"
  url "https://registry.npmjs.org/graphqurl/-/graphqurl-1.0.3.tgz"
  sha256 "77b38dc7f34b7e4f4d3550896a2c4a78ef31a76f202de03b9efaabfc5060ee82"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7d29fea61417e781508114b37928fdf1337a17d0234f83aa5a2dbbd7652eaea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eeb0c8c2c3e60b9b3806aeec12e9bf33db690e253f67fe041019249de96c8e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eeb0c8c2c3e60b9b3806aeec12e9bf33db690e253f67fe041019249de96c8e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeb0c8c2c3e60b9b3806aeec12e9bf33db690e253f67fe041019249de96c8e2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "43e1db21f854ac858fd2daa71b122158ca3d0df06be07f901995feb26c4f67e6"
    sha256 cellar: :any_skip_relocation, ventura:        "43e1db21f854ac858fd2daa71b122158ca3d0df06be07f901995feb26c4f67e6"
    sha256 cellar: :any_skip_relocation, monterey:       "43e1db21f854ac858fd2daa71b122158ca3d0df06be07f901995feb26c4f67e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c810c89e48bc94b6b72d5dee1b950dda7fe604ad25949edeb4d163be64056d51"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = Utils.safe_popen_read(bin/"gq", "https://graphqlzero.almansi.me/api",
                                              "--header", "Content-Type: application/json",
                                              "--introspect")
    assert_match "type Query {", output
  end
end
