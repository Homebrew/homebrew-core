class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.103/bee-1.103.zip"
  sha256 "7b44f6994b4e658420044891922486d1ffcd96d7af27cf3a3b6cd2ca0ec8a599"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b9536814860357752a5f4eaff76f26e4a1f28bb48dad82639e0fb285359254f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b9536814860357752a5f4eaff76f26e4a1f28bb48dad82639e0fb285359254f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b9536814860357752a5f4eaff76f26e4a1f28bb48dad82639e0fb285359254f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b9536814860357752a5f4eaff76f26e4a1f28bb48dad82639e0fb285359254f"
    sha256 cellar: :any_skip_relocation, ventura:        "1b9536814860357752a5f4eaff76f26e4a1f28bb48dad82639e0fb285359254f"
    sha256 cellar: :any_skip_relocation, monterey:       "1b9536814860357752a5f4eaff76f26e4a1f28bb48dad82639e0fb285359254f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ace438ba7c6eeced9c133566f3cccb1b0f5ec9daf106c7628ff6d73735e690a"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    (bin/"bee").write_env_script libexec/"bin/bee", Language::Java.java_home_env
  end

  test do
    (testpath/"bee.properties").write <<~EOS
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "-d", testpath/"bee", "dbchange:create", "new-file"
  end
end
