require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.5.4.tgz"
  sha256 "324d8f1854c6d348192e54221c3dcec92ddabe836614ec8f43262b5a0ab1743c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef20181bfc7f65f90812e674b79bf724c7e6ac4bd0a7db33493db21100c16ff5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef20181bfc7f65f90812e674b79bf724c7e6ac4bd0a7db33493db21100c16ff5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef20181bfc7f65f90812e674b79bf724c7e6ac4bd0a7db33493db21100c16ff5"
    sha256 cellar: :any_skip_relocation, ventura:        "0d7f9f204a67affe3d8c8581638cd5e3d1188d666e651a9761ee107aec4edcbd"
    sha256 cellar: :any_skip_relocation, monterey:       "0d7f9f204a67affe3d8c8581638cd5e3d1188d666e651a9761ee107aec4edcbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d7f9f204a67affe3d8c8581638cd5e3d1188d666e651a9761ee107aec4edcbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e49cb387c746fb8a7b50c7e2d35a5715522b962bc3c7c5feb8e1da510b62a51"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~EOS
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    EOS

    expected_dbml = <<~EOS
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    EOS

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end
