class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.10.9.tar.gz"
  sha256 "15c7cc80cc5e1e2d6ef33bffce1b6a26729f45b80453714f424eec03974f7e14"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91cd22b2b6b8793e72f37916d451fe1fd7c89cab46bce1de95c6d27045fe84f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d9eb5a49b5d262d5ca7fd0558a59f0b96e403d4f5bf9a71436fbdd15d3573fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76a9fa0bad678e7e38c7bad9ca6dc3479f9102376eb3b6aacd39d57bbef2d484"
    sha256 cellar: :any_skip_relocation, sonoma:        "b205bc5e83253166087d3895ba61466bbb6d0a30a96be3a041907bf03b0a8fcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "154313920e25dc36c56c26aa567af0753f3092949f7d6b4a497e671808deea56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5b01f1a9c61c9acbae2b41a803c5e7cd7c471cab324ae399fcbaf3c895741d"
  end

  depends_on "go" => :build
  # Avoid C++20 from Node 23+ until "@parcel/watcher >= 2.2.0" for "node-addon-api >= 4"
  # Issue ref: https://github.com/nodejs/node-addon-api/issues/1007
  depends_on "node@22" => :build
  depends_on "python-setuptools" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    # Check if workarounds can be removed
    if build.stable?
      yarn_lock = File.read("yarn.lock")

      # distutils usage removed in https://github.com/nodejs/node-gyp/commit/707927cd579205ef2b4b17e61c1cce24c056b452
      node_gyp_version = Version.new(yarn_lock[%r{/node-gyp[._-]v?(\d+(?:\.\d+)+)\.t}i, 1])
      odie "Remove `python-setuptools` dependency!" if node_gyp_version >= 10

      # node 22 (V8 12) fix in https://github.com/nodejs/nan/commit/1b630ddb3412cde35b64513662b440f9fd71e1ff
      nan_version = Version.new(yarn_lock[%r{/nan[._-]v?(\d+(?:\.\d+)+)\.t}i, 1])
      odie "Remove `nan` resolution workaround!" if nan_version >= "2.19.0"
    end

    # Workaround to build with newer node until `nan` dependency is updated
    # https://github.com/influxdata/chronograf/issues/6040
    package_json = JSON.parse(File.read("package.json"))
    (package_json["resolutions"] ||= {})["nan"] = "2.23.0"
    File.write("package.json", JSON.pretty_generate(package_json))

    ENV["npm_config_build_from_source"] = "true"
    ENV.deparallelize
    system "make"
    bin.install "chronograf"
  end

  service do
    run opt_bin/"chronograf"
    keep_alive true
    error_log_path var/"log/chronograf.log"
    log_path var/"log/chronograf.log"
    working_dir var
  end

  test do
    port = free_port
    pid = spawn bin/"chronograf", "--port=#{port}"
    sleep 10
    output = shell_output("curl -s 0.0.0.0:#{port}/chronograf/v1/")
    sleep 1
    assert_match "/chronograf/v1/layouts", output
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
