class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "https://www.embulk.org/"
  url "https://github.com/embulk/embulk/releases/download/v0.11.5/embulk-0.11.5.jar"
  sha256 "e2f298db60c2fe1cc17c377edf7215c7005b5d106d151b1a4278a508e4a32e47"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fc718acf04dd0ffd6e04dc816490ba13bc8af9b0de9d45b169cc6b55a9e936f7"
  end

  # From https://www.embulk.org,
  # > Embulk v0.11 officially supports only Java 8, but expected to work somehow with Java 11, 17, and 21.
  #
  # Since `openjdk@8` does not support ARM macOS, we need to use newer version.
  # The same OpenJDK version must be used on all platforms due to a brew bug relocating `:all` bottles.
  # See: https://github.com/Homebrew/brew/issues/18695
  depends_on "openjdk@21"

  def install
    libexec.install "embulk-#{version}.jar"
    bin.write_jar_script libexec/"embulk-#{version}.jar", "embulk", java_version: "21"
  end

  test do
    # In order to install a different plugin, we need JRuby, but brew `jruby`
    # seems to hit some failures so using a resource.
    resource "jruby-complete" do
      url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-complete/9.4.8.0/jruby-complete-9.4.8.0.jar"
      sha256 "ce537f21a2cfc34cf91fc834d8d1c663c6f3b5bca57cacd45fd4c47ede71c303"
    end
    testpath.install resource("jruby-complete")
    jruby = "jruby=file://#{testpath}/jruby-complete-#{resource("jruby-complete").version}.jar"

    (testpath/"config.yml").write <<~YAML
      in:
        type: http
        url: https://formulae.brew.sh/api/analytics/brew-command-run/30d.json
        parser:
          type: json
          root: /items
          flatten_json_array: true
          columns:
            - {name: number, type: long}
            - {name: command_run, type: string}
            - {name: count, type: string}
            - {name: percent, type: double}
      out:
        type: stdout
    YAML

    ENV["GEM_HOME"] = testpath/"gems"
    system bin/"embulk", "-X", jruby, "gem", "install", "embulk", "--version", version.to_s
    system bin/"embulk", "-X", jruby, "gem", "install", "embulk-input-http", "msgpack"
    assert_match <<~EOS.chomp, shell_output("#{bin}/embulk -X #{jruby} preview config.yml")
      +-------------+-----------------------------+--------------+----------------+
      | number:long |          command_run:string | count:string | percent:double |
      +-------------+-----------------------------+--------------+----------------+
      |           1 |                        list |
    EOS
    output = shell_output("#{bin}/embulk -X #{jruby} run config.yml")
    assert_match(/^1,list,.*\n2,/, output)

    # Recent macOS requires giving Terminal permissions to access files on a
    # network volume in order to use Embulk's basic file input plugin.
    return if OS.mac? && MacOS.version >= :ventura

    system bin/"embulk", "example", "./try1"
    system bin/"embulk", "guess", "./try1/seed.yml", "-o", "config.yml"
    system bin/"embulk", "preview", "config.yml"
    system bin/"embulk", "run", "config.yml"
  end
end
