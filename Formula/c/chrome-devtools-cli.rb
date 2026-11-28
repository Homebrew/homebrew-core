class ChromeDevtoolsCli < Formula
  desc "Chrome DevTools Protocol CLI that auto-connects to your running Chrome"
  homepage "https://github.com/aeroxy/chrome-devtools-cli"
  url "https://github.com/aeroxy/chrome-devtools-cli/archive/refs/tags/2.5.0.tar.gz"
  sha256 "d035b1088a8743be9c2ea6634f3de6e51cb5b84e98d8df4304d8925f0e27fca7"
  license "MIT"
  head "https://github.com/aeroxy/chrome-devtools-cli.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # These commands parse local heap snapshots, so they need neither a running
    # Chrome (the other commands connect to one and ask the user to approve it)
    # nor the network.
    meta = '{"node_fields":["type","name","id","self_size","edge_count","detachedness"],' \
           '"node_types":[["hidden","array","string","object","code","closure","regexp","number",' \
           '"native","synthetic"],"string","number","number","number","number"],' \
           '"edge_fields":["type","name_or_index","to_node"],' \
           '"edge_types":[["context","element","property","internal","hidden","shortcut","weak"],' \
           '"string_or_number","node"]}'
    (testpath/"base.heapsnapshot").write <<~JSON
      {"snapshot":{"meta":#{meta}},"nodes":[9,0,1,0,1,0,3,1,3,10,0,0],"edges":[2,2,6],"strings":["","Foo","child"]}
    JSON
    (testpath/"current.heapsnapshot").write <<~JSON
      {"snapshot":{"meta":#{meta}},"nodes":[9,0,1,0,2,0,3,1,3,10,0,0,3,3,5,20,0,0],"edges":[2,2,6,2,2,12],"strings":["","Foo","child","Bar"]}
    JSON

    # One `Bar` object of 20 bytes exists only in the second snapshot.
    output = shell_output("#{bin}/chrome-devtools compare-heapsnapshots " \
                          "--base #{testpath}/base.heapsnapshot --current #{testpath}/current.heapsnapshot")
    assert_match "0,Bar,,1,0,1,20,0,20", output

    output = shell_output("#{bin}/chrome-devtools inspect-heapsnapshot-node " \
                          "--file-path #{testpath}/current.heapsnapshot --node-id 5")
    assert_match "child,property,5,Bar,object,20", output
  end
end
