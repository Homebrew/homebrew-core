class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  # TODO: Add stable url when v1.0.0 is released
  head "https://github.com/hasura/graphql-engine.git"

  depends_on "go" => :build

  def install
    Dir.chdir("cli")
    modname = "github.com/hasura/graphql-engine/cli"
    exflags = '-extldflags "-static"'
    ldflags = "-ldflags '-X #{modname}/version.BuildVersion=#{version} -s -w #{exflags}'"
    File.open("build.sh", "w") do |file|
      # Using a build file to work around an odd string interpolation issue with the single/double quotes
      file.puts "set -eox pipefail"
      file.puts "go mod init #{modname}"
      file.puts "go build -o ./bin/hasura -a -v #{ldflags} ./cmd/hasura/"
    end
    chmod "+x", "build.sh"
    system "./build.sh"
    bin.install "./bin/hasura"
  end

  test do
    system "hasura", "version"
  end
end
