class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  license "GPL-3.0-only"
  head "https://github.com/Ehco1996/ehco.git", branch: "master"

  stable do
    url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.1.5.tar.gz"
    sha256 "d6883b1ecdf4551f0b8fcbc8863089de0c5971944d0d2fa778835fd2ec76cfe8"

    # go1.26 build patch, upstream release request, https://github.com/Ehco1996/ehco/issues/418
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b8caa88f618075e34f5038eafe1aaaa09b68f0d2dc3a08ee1d9d2edafbbad14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f67b21d26063cf53576be6b3e1966b1cf63bacc1209163a257fa2f5cd214d668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d3f0180c2efd1366eda80945efe3246156a52b3a8b889816880dbc0cd820d85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c4346f2aa4c0db369932c13d0c1ca3988b0f2a28509b536febf2bc8bdd51509"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c9a614d07b9a81f89941601b9ab8f4c978414b83c0ecef938d2e0c510cdea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21e9e6ba85a46f6cc8f3bf833db44298bb489bd895091ef13c843f5f17d95d1e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Ehco1996/ehco/internal/constant.GitBranch=master
      -X github.com/Ehco1996/ehco/internal/constant.GitRevision=#{tap.user}
      -X github.com/Ehco1996/ehco/internal/constant.BuildTime=#{time.iso8601}
    ]
    # -tags added here are via upstream's Makefile/CI builds
    tags = "nofibrechannel,nomountstats"

    system "go", "build", *std_go_args(ldflags:, tags:), "cmd/ehco/main.go"
  end

  test do
    version_info = shell_output("#{bin}/ehco -v 2>&1")
    assert_match "Version=#{version}", version_info

    # run tcp server
    server_port = free_port
    server = TCPServer.new(server_port)
    server_pid = fork do
      session = server.accept
      session.puts "Hello world!"
      session.close
    end
    sleep 1

    # run ehco server
    listen_port = free_port
    ehco_pid = spawn bin/"ehco", "-l", "localhost:#{listen_port}", "-r", "localhost:#{server_port}"
    sleep 1

    TCPSocket.open("localhost", listen_port) do |sock|
      assert_match "Hello world!", sock.gets
    end
  ensure
    Process.kill "TERM", ehco_pid if ehco_pid
    Process.kill "TERM", server_pid if server_pid
  end
end

__END__
diff --git a/go.mod b/go.mod
index 23f0089..58f1136 100644
--- a/go.mod
+++ b/go.mod
@@ -1,8 +1,6 @@
 module github.com/Ehco1996/ehco
 
-go 1.22
-
-toolchain go1.22.1
+go 1.25
 
 require (
 	github.com/alecthomas/kingpin/v2 v2.4.0
@@ -17,27 +15,26 @@ require (
 	github.com/prometheus/client_model v0.6.1
 	github.com/prometheus/common v0.55.0
 	github.com/prometheus/node_exporter v1.8.2
-	github.com/sagernet/sing v0.4.2
+	github.com/sagernet/sing v0.5.1
 	github.com/sagernet/sing-box v1.9.4
-	github.com/stretchr/testify v1.9.0
+	github.com/stretchr/testify v1.11.1
 	github.com/urfave/cli/v2 v2.27.4
-	github.com/xtls/xray-core v1.8.23
+	github.com/xtls/xray-core v1.251015.0
 	go.uber.org/atomic v1.11.0
 	go.uber.org/zap v1.27.0
-	golang.org/x/sync v0.8.0
-	golang.org/x/time v0.6.0
-	google.golang.org/grpc v1.65.0
+	golang.org/x/sync v0.17.0
+	golang.org/x/time v0.7.0
+	google.golang.org/grpc v1.76.0
 	modernc.org/sqlite v1.32.0
 )
 
 require (
-	github.com/OmarTariq612/goech v0.0.0-20240405204721-8e2e1dafd3a0 // indirect
 	github.com/alecthomas/units v0.0.0-20231202071711-9a357b53e9c9 // indirect
 	github.com/andybalholm/brotli v1.1.0 // indirect
 	github.com/beevik/ntp v1.4.2 // indirect
 	github.com/beorn7/perks v1.0.1 // indirect
 	github.com/cespare/xxhash/v2 v2.3.0 // indirect
-	github.com/cloudflare/circl v1.3.9 // indirect
+	github.com/cloudflare/circl v1.6.1 // indirect
 	github.com/coreos/go-systemd/v22 v22.5.0 // indirect
 	github.com/cpuguy83/go-md2man/v2 v2.0.4 // indirect
 	github.com/davecgh/go-spew v1.1.1 // indirect
@@ -46,19 +43,17 @@ require (
 	github.com/dgryski/go-metro v0.0.0-20211217172704-adc40b04c140 // indirect
 	github.com/dustin/go-humanize v1.0.1 // indirect
 	github.com/ema/qdisc v1.0.0 // indirect
-	github.com/francoispqt/gojay v1.2.13 // indirect
 	github.com/fsnotify/fsnotify v1.7.0 // indirect
 	github.com/ghodss/yaml v1.0.1-0.20220118164431-d8423dcdf344 // indirect
 	github.com/go-kit/log v0.2.1 // indirect
 	github.com/go-logfmt/logfmt v0.6.0 // indirect
 	github.com/go-ole/go-ole v1.3.0 // indirect
-	github.com/go-task/slim-sprig/v3 v3.0.0 // indirect
 	github.com/gobwas/httphead v0.1.0 // indirect
 	github.com/gobwas/pool v0.2.1 // indirect
 	github.com/godbus/dbus/v5 v5.1.0 // indirect
 	github.com/golang-jwt/jwt v3.2.2+incompatible // indirect
 	github.com/google/btree v1.1.2 // indirect
-	github.com/google/go-cmp v0.6.0 // indirect
+	github.com/google/go-cmp v0.7.0 // indirect
 	github.com/google/pprof v0.0.0-20240528025155-186aa0362fba // indirect
 	github.com/google/uuid v1.6.0 // indirect
 	github.com/gorilla/websocket v1.5.3 // indirect
@@ -82,20 +77,19 @@ require (
 	github.com/mdlayher/netlink v1.7.2 // indirect
 	github.com/mdlayher/socket v0.5.1 // indirect
 	github.com/mdlayher/wifi v0.2.0 // indirect
-	github.com/miekg/dns v1.1.61 // indirect
+	github.com/miekg/dns v1.1.68 // indirect
 	github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822 // indirect
 	github.com/ncruces/go-strftime v0.1.9 // indirect
-	github.com/onsi/ginkgo/v2 v2.19.0 // indirect
 	github.com/opencontainers/selinux v1.11.0 // indirect
 	github.com/oschwald/maxminddb-golang v1.12.0 // indirect
 	github.com/pelletier/go-toml v1.9.5 // indirect
-	github.com/pires/go-proxyproto v0.7.0 // indirect
+	github.com/pires/go-proxyproto v0.8.1 // indirect
 	github.com/pmezard/go-difflib v1.0.0 // indirect
 	github.com/prometheus-community/go-runit v0.1.0 // indirect
 	github.com/prometheus/procfs v0.15.1 // indirect
-	github.com/quic-go/qpack v0.4.0 // indirect
-	github.com/quic-go/quic-go v0.45.1 // indirect
-	github.com/refraction-networking/utls v1.6.7 // indirect
+	github.com/quic-go/qpack v0.5.1 // indirect
+	github.com/quic-go/quic-go v0.55.0 // indirect
+	github.com/refraction-networking/utls v1.8.1 // indirect
 	github.com/remyoudompheng/bigfft v0.0.0-20230129092748-24d4a6f8daec // indirect
 	github.com/riobard/go-bloom v0.0.0-20200614022211-cdc8013cb5b3 // indirect
 	github.com/russross/blackfriday/v2 v2.1.0 // indirect
@@ -109,30 +103,29 @@ require (
 	github.com/v2fly/ss-bloomring v0.0.0-20210312155135-28617310f63e // indirect
 	github.com/valyala/bytebufferpool v1.0.0 // indirect
 	github.com/valyala/fasttemplate v1.2.2 // indirect
-	github.com/vishvananda/netlink v1.2.1-beta.2.0.20230316163032-ced5aaba43e3 // indirect
-	github.com/vishvananda/netns v0.0.4 // indirect
+	github.com/vishvananda/netlink v1.3.1 // indirect
+	github.com/vishvananda/netns v0.0.5 // indirect
 	github.com/xhit/go-str2duration/v2 v2.1.0 // indirect
 	github.com/xrash/smetrics v0.0.0-20240521201337-686a1a2994c1 // indirect
-	github.com/xtls/reality v0.0.0-20240712055506-48f0b2d5ed6d // indirect
-	go.uber.org/mock v0.4.0 // indirect
+	github.com/xtls/reality v0.0.0-20251014195629-e4eec4520535 // indirect
 	go.uber.org/multierr v1.11.0 // indirect
 	go4.org/netipx v0.0.0-20231129151722-fdeea329fbba // indirect
-	golang.org/x/crypto v0.25.0 // indirect
+	golang.org/x/crypto v0.43.0 // indirect
 	golang.org/x/exp v0.0.0-20240531132922-fd00a4e0eefc // indirect
-	golang.org/x/mod v0.18.0 // indirect
-	golang.org/x/net v0.27.0 // indirect
-	golang.org/x/sys v0.22.0 // indirect
-	golang.org/x/text v0.16.0 // indirect
-	golang.org/x/tools v0.22.0 // indirect
+	golang.org/x/mod v0.28.0 // indirect
+	golang.org/x/net v0.46.0 // indirect
+	golang.org/x/sys v0.37.0 // indirect
+	golang.org/x/text v0.30.0 // indirect
+	golang.org/x/tools v0.37.0 // indirect
 	golang.zx2c4.com/wintun v0.0.0-20230126152724-0fa3db229ce2 // indirect
 	golang.zx2c4.com/wireguard v0.0.0-20231211153847-12269c276173 // indirect
-	google.golang.org/genproto/googleapis/rpc v0.0.0-20240528184218-531527333157 // indirect
-	google.golang.org/protobuf v1.34.2 // indirect
+	google.golang.org/genproto/googleapis/rpc v0.0.0-20250804133106-a7a43d27e69b // indirect
+	google.golang.org/protobuf v1.36.10 // indirect
 	gopkg.in/yaml.v2 v2.4.0 // indirect
 	gopkg.in/yaml.v3 v3.0.1 // indirect
-	gvisor.dev/gvisor v0.0.0-20231202080848-1f7806d17489 // indirect
+	gvisor.dev/gvisor v0.0.0-20250428193742-2d800c3129d5 // indirect
 	howett.net/plist v1.0.1 // indirect
-	lukechampine.com/blake3 v1.3.0 // indirect
+	lukechampine.com/blake3 v1.4.1 // indirect
 	modernc.org/gc/v3 v3.0.0-20240107210532-573471604cb6 // indirect
 	modernc.org/libc v1.55.3 // indirect
 	modernc.org/mathutil v1.6.0 // indirect
diff --git a/go.sum b/go.sum
index a45dc09..2153b6c 100644
--- a/go.sum
+++ b/go.sum
@@ -1,37 +1,19 @@
-cloud.google.com/go v0.26.0/go.mod h1:aQUYkXzVsufM+DwF1aE+0xfcU+56JwCaLick0ClmMTw=
-cloud.google.com/go v0.31.0/go.mod h1:aQUYkXzVsufM+DwF1aE+0xfcU+56JwCaLick0ClmMTw=
-cloud.google.com/go v0.34.0/go.mod h1:aQUYkXzVsufM+DwF1aE+0xfcU+56JwCaLick0ClmMTw=
-cloud.google.com/go v0.37.0/go.mod h1:TS1dMSSfndXH133OKGwekG838Om/cQT0BUHV3HcBgoo=
-dmitri.shuralyov.com/app/changes v0.0.0-20180602232624-0a106ad413e3/go.mod h1:Yl+fi1br7+Rr3LqpNJf1/uxUdtRUV+Tnj0o93V2B9MU=
-dmitri.shuralyov.com/html/belt v0.0.0-20180602232347-f7d459c86be0/go.mod h1:JLBrvjyP0v+ecvNYvCpyZgu5/xkfAUhi6wJj28eUfSU=
-dmitri.shuralyov.com/service/change v0.0.0-20181023043359-a85b471d5412/go.mod h1:a1inKt/atXimZ4Mv927x+r7UpyzRUf4emIoiiSC2TN4=
-dmitri.shuralyov.com/state v0.0.0-20180228185332-28bcc343414c/go.mod h1:0PRwlb0D6DFvNNtx+9ybjezNCa8XF0xaYcETyp6rHWU=
-git.apache.org/thrift.git v0.0.0-20180902110319-2566ecd5d999/go.mod h1:fPE2ZNJGynbRyZ4dJvy6G277gSllfV2HJqblrnkyeyg=
-github.com/BurntSushi/toml v0.3.1/go.mod h1:xHWCNGjB5oqiDr8zfno3MHue2Ht5sIBksp03qcyfWMU=
-github.com/OmarTariq612/goech v0.0.0-20240405204721-8e2e1dafd3a0 h1:Wo41lDOevRJSGpevP+8Pk5bANX7fJacO2w04aqLiC5I=
-github.com/OmarTariq612/goech v0.0.0-20240405204721-8e2e1dafd3a0/go.mod h1:FVGavL/QEBQDcBpr3fAojoK17xX5k9bicBphrOpP7uM=
 github.com/alecthomas/kingpin/v2 v2.4.0 h1:f48lwail6p8zpO1bC4TxtqACaGqHYA22qkHjHpqDjYY=
 github.com/alecthomas/kingpin/v2 v2.4.0/go.mod h1:0gyi0zQnjuFk8xrkNKamJoyUo382HRL7ATRpFZCw6tE=
 github.com/alecthomas/units v0.0.0-20231202071711-9a357b53e9c9 h1:ez/4by2iGztzR4L0zgAOR8lTQK9VlyBVVd7G4omaOQs=
 github.com/alecthomas/units v0.0.0-20231202071711-9a357b53e9c9/go.mod h1:OMCwj8VM1Kc9e19TLln2VL61YJF0x1XFtfdL4JdbSyE=
 github.com/andybalholm/brotli v1.1.0 h1:eLKJA0d02Lf0mVpIDgYnqXcUn0GqVmEFny3VuID1U3M=
 github.com/andybalholm/brotli v1.1.0/go.mod h1:sms7XGricyQI9K10gOSf56VKKWS4oLer58Q+mhRPtnY=
-github.com/anmitsu/go-shlex v0.0.0-20161002113705-648efa622239/go.mod h1:2FmKhYUyUczH0OGQWaF5ceTx0UBShxjsH6f8oGKYe2c=
 github.com/beevik/ntp v1.4.2 h1:cjYhZqczanf6br/ocViahE75ipj7CmKQAh7fSBaCNK4=
 github.com/beevik/ntp v1.4.2/go.mod h1:zkATLTt8VUZuOfYX2KgOnir4yvtAxWbnUUA24umXFnc=
-github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod h1:Dwedo/Wpr24TaqPxmxbtue+5NUziq4I4S80YR8gNf3Q=
 github.com/beorn7/perks v1.0.1 h1:VlbKKnNfV8bJzeqoa4cOKqO6bYr3WgKZxO8Z16+hsOM=
 github.com/beorn7/perks v1.0.1/go.mod h1:G2ZrVWU2WbWT9wwq4/hrbKbnv/1ERSJQ0ibhJ6rlkpw=
-github.com/bradfitz/go-smtpd v0.0.0-20170404230938-deb6d6237625/go.mod h1:HYsPBTaaSFSlLx/70C2HPIMNZpVV8+vt/A+FMnYP11g=
-github.com/buger/jsonparser v0.0.0-20181115193947-bf1c66bbce23/go.mod h1:bbYlZJ7hK1yFx9hf58LP0zeX7UjIGs20ufpu3evjr+s=
 github.com/cespare/xxhash/v2 v2.3.0 h1:UL815xU9SqsFlibzuggzjXhog7bL6oX9BbNZnL2UFvs=
 github.com/cespare/xxhash/v2 v2.3.0/go.mod h1:VGX0DQ3Q6kWi7AoAeZDth3/j3BFtOZR5XLFGgcrjCOs=
 github.com/cilium/ebpf v0.12.3 h1:8ht6F9MquybnY97at+VDZb3eQQr8ev79RueWeVaEcG4=
 github.com/cilium/ebpf v0.12.3/go.mod h1:TctK1ivibvI3znr66ljgi4hqOT8EYQjz1KWBfb1UVgM=
-github.com/client9/misspell v0.3.4/go.mod h1:qj6jICC3Q7zFZvVWo7KLAzC3yx5G7kyvSDkc90ppPyw=
-github.com/cloudflare/circl v1.3.9 h1:QFrlgFYf2Qpi8bSpVPK1HBvWpx16v/1TZivyo7pGuBE=
-github.com/cloudflare/circl v1.3.9/go.mod h1:PDRU+oXvdD7KCtgKxW95M5Z8BpSCJXQORiZFnBQS5QU=
-github.com/coreos/go-systemd v0.0.0-20181012123002-c6f51f82210d/go.mod h1:F5haX7vjVVG0kc13fIWeqUViNPyEJxv/OmvnBo0Yme4=
+github.com/cloudflare/circl v1.6.1 h1:zqIqSPIndyBh1bjLVVDHMPpVKqp8Su/V+6MeDzzQBQ0=
+github.com/cloudflare/circl v1.6.1/go.mod h1:uddAzsPgqdMAYatqJ0lsjX1oECcQLIlRpzZh3pJrofs=
 github.com/coreos/go-systemd/v22 v22.5.0 h1:RrqgGjYQKalulkV8NGVIfkXQf6YYmOyiJKk8iXXhfZs=
 github.com/coreos/go-systemd/v22 v22.5.0/go.mod h1:Y58oyj3AT4RCenI/lSvhwexgC+NSVTIJ3seZv2GcEnc=
 github.com/cpuguy83/go-md2man/v2 v2.0.4 h1:wfIWP927BUkWJb2NmU/kNDYIBTh/ziUX91+lVfRxZq4=
@@ -46,40 +28,32 @@ github.com/dennwc/ioctl v1.0.0/go.mod h1:ellh2YB5ldny99SBU/VX7Nq0xiZbHphf1DrtHxx
 github.com/dgryski/go-metro v0.0.0-20200812162917-85c65e2d0165/go.mod h1:c9O8+fpSOX1DM8cPNSkX/qsBWdkD4yd2dpciOWQjpBw=
 github.com/dgryski/go-metro v0.0.0-20211217172704-adc40b04c140 h1:y7y0Oa6UawqTFPCDw9JG6pdKt4F9pAhHv0B7FMGaGD0=
 github.com/dgryski/go-metro v0.0.0-20211217172704-adc40b04c140/go.mod h1:c9O8+fpSOX1DM8cPNSkX/qsBWdkD4yd2dpciOWQjpBw=
-github.com/dustin/go-humanize v1.0.0/go.mod h1:HtrtbFcZ19U5GC7JDqmcUSB87Iq5E25KnS6fMYU6eOk=
 github.com/dustin/go-humanize v1.0.1 h1:GzkhY7T5VNhEkwH0PVJgjz+fX1rhBrR7pRT3mDkpeCY=
 github.com/dustin/go-humanize v1.0.1/go.mod h1:Mu1zIs6XwVuF/gI1OepvI0qD18qycQx+mFykh5fBlto=
 github.com/ema/qdisc v1.0.0 h1:EHLG08FVRbWLg8uRICa3xzC9Zm0m7HyMHfXobWFnXYg=
 github.com/ema/qdisc v1.0.0/go.mod h1:FhIc0fLYi7f+lK5maMsesDqwYojIOh3VfRs8EVd5YJQ=
 github.com/fatih/color v1.16.0 h1:zmkK9Ngbjj+K0yRhTVONQh1p/HknKYSlNT+vZCzyokM=
 github.com/fatih/color v1.16.0/go.mod h1:fL2Sau1YI5c0pdGEVCbKQbLXB6edEj1ZgiY4NijnWvE=
-github.com/flynn/go-shlex v0.0.0-20150515145356-3f9db97f8568/go.mod h1:xEzjJPgXI435gkrCt3MPfRiAkVrwSbHsst4LCFVfpJc=
-github.com/francoispqt/gojay v1.2.13 h1:d2m3sFjloqoIUQU3TsHBgj6qg/BVGlTBeHDUmyJnXKk=
-github.com/francoispqt/gojay v1.2.13/go.mod h1:ehT5mTG4ua4581f1++1WLG0vPdaA9HaiDsoyrBGkyDY=
-github.com/fsnotify/fsnotify v1.4.7/go.mod h1:jwhsz4b93w/PPRr/qN1Yymfu8t87LnFCMoQvtojpjFo=
 github.com/fsnotify/fsnotify v1.7.0 h1:8JEhPFa5W2WU7YfeZzPNqzMP6Lwt7L2715Ggo0nosvA=
 github.com/fsnotify/fsnotify v1.7.0/go.mod h1:40Bi/Hjc2AVfZrqy+aj+yEI+/bRxZnMJyTJwOpGvigM=
 github.com/getsentry/sentry-go v0.28.1 h1:zzaSm/vHmGllRM6Tpx1492r0YDzauArdBfkJRtY6P5k=
 github.com/getsentry/sentry-go v0.28.1/go.mod h1:1fQZ+7l7eeJ3wYi82q5Hg8GqAPgefRq+FP/QhafYVgg=
-github.com/ghodss/yaml v1.0.0/go.mod h1:4dBDuWmgqj2HViK6kFavaiC9ZROes6MMH2rRYeMEF04=
 github.com/ghodss/yaml v1.0.1-0.20220118164431-d8423dcdf344 h1:Arcl6UOIS/kgO2nW3A65HN+7CMjSDP/gofXL4CZt1V4=
 github.com/ghodss/yaml v1.0.1-0.20220118164431-d8423dcdf344/go.mod h1:GIjDIg/heH5DOkXY3YJ/wNhfHsQHoXGjl8G8amsYQ1I=
-github.com/gliderlabs/ssh v0.1.1/go.mod h1:U7qILu1NlMHj9FlMhZLlkCdDnU1DBEAqr0aevW3Awn0=
-github.com/go-errors/errors v1.0.1/go.mod h1:f4zRHt4oKfwPJE5k8C9vpYG+aDHdBFUsgrm6/TyX73Q=
 github.com/go-errors/errors v1.4.2 h1:J6MZopCL4uSllY1OfXM374weqZFFItUbrImctkmUxIA=
 github.com/go-errors/errors v1.4.2/go.mod h1:sIVyrIiJhuEF+Pj9Ebtd6P/rEYROXFi3BopGUQ5a5Og=
 github.com/go-kit/log v0.2.1 h1:MRVx0/zhvdseW+Gza6N9rVzU/IVzaeE1SFI4raAhmBU=
 github.com/go-kit/log v0.2.1/go.mod h1:NwTd00d/i8cPZ3xOwwiv2PO5MOcx78fFErGNcVmBjv0=
 github.com/go-logfmt/logfmt v0.6.0 h1:wGYYu3uicYdqXVgoYbvnkrPVXkuLM1p1ifugDMEdRi4=
 github.com/go-logfmt/logfmt v0.6.0/go.mod h1:WYhtIu8zTZfxdn5+rREduYbwxfcBr/Vr6KEVveWlfTs=
-github.com/go-logr/logr v1.4.1 h1:pKouT5E8xu9zeFC39JXRDukb6JFQPXM5p5I91188VAQ=
-github.com/go-logr/logr v1.4.1/go.mod h1:9T104GzyrTigFIr8wt5mBrctHMim0Nb2HLGrmQ40KvY=
+github.com/go-logr/logr v1.4.3 h1:CjnDlHq8ikf6E492q6eKboGOC0T8CDaOvkHCIg8idEI=
+github.com/go-logr/logr v1.4.3/go.mod h1:9T104GzyrTigFIr8wt5mBrctHMim0Nb2HLGrmQ40KvY=
+github.com/go-logr/stdr v1.2.2 h1:hSWxHoqTgW2S2qGc0LTAI563KZ5YKYRhT3MFKZMbjag=
+github.com/go-logr/stdr v1.2.2/go.mod h1:mMo/vtBO5dYbehREoey6XUKy/eSumjCCveDpRre4VKE=
 github.com/go-ole/go-ole v1.3.0 h1:Dt6ye7+vXGIKZ7Xtk4s6/xVdGDQynvom7xCFEdWr6uE=
 github.com/go-ole/go-ole v1.3.0/go.mod h1:5LS6F96DhAwUc7C+1HLexzMXY1xGRSryjyPPKW6zv78=
 github.com/go-ping/ping v1.1.0 h1:3MCGhVX4fyEUuhsfwPrsEdQw6xspHkv5zHsiSoDFZYw=
 github.com/go-ping/ping v1.1.0/go.mod h1:xIFjORFzTxqIV/tDVGO4eDy/bLuSyawEeojSm3GfRGk=
-github.com/go-task/slim-sprig/v3 v3.0.0 h1:sUs3vkvUymDpBKi3qH1YSqBQk9+9D/8M2mN1vB6EwHI=
-github.com/go-task/slim-sprig/v3 v3.0.0/go.mod h1:W848ghGpv3Qj3dhTPRyJypKRiqCdHZiAzKg9hl15HA8=
 github.com/gobwas/httphead v0.1.0 h1:exrUm0f4YX0L7EBwZHuCF4GDp8aJfVeBrlLQrs6NqWU=
 github.com/gobwas/httphead v0.1.0/go.mod h1:O/RXo79gxV8G+RqlR/otEwx4Q36zl9rqC5u12GKvMCM=
 github.com/gobwas/pool v0.2.1 h1:xfeeEhW7pwmX8nuLVlqbzVc7udMDrwetjEv+TZIz1og=
@@ -89,39 +63,23 @@ github.com/gobwas/ws v1.4.0/go.mod h1:G3gNqMNtPppf5XUz7O4shetPpcZ1VJ7zt18dlUeakr
 github.com/godbus/dbus/v5 v5.0.4/go.mod h1:xhWf0FNVPg57R7Z0UbKHbJfkEywrmjJnf7w5xrFpKfA=
 github.com/godbus/dbus/v5 v5.1.0 h1:4KLkAxT3aOY8Li4FRJe/KvhoNFFxo0m6fNuFUO8QJUk=
 github.com/godbus/dbus/v5 v5.1.0/go.mod h1:xhWf0FNVPg57R7Z0UbKHbJfkEywrmjJnf7w5xrFpKfA=
-github.com/gogo/protobuf v1.1.1/go.mod h1:r8qH/GZQm5c6nD/R0oafs1akxWv10x8SbQlK7atdtwQ=
 github.com/golang-jwt/jwt v3.2.2+incompatible h1:IfV12K8xAKAnZqdXVzCZ+TOjboZ2keLg81eXfW3O+oY=
 github.com/golang-jwt/jwt v3.2.2+incompatible/go.mod h1:8pz2t5EyA70fFQQSrl6XZXzqecmYZeUEB8OUGHkxJ+I=
-github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod h1:SBH7ygxi8pfUlaOkMMuAQtPIUF8ecWP5IEl/CR7VP2Q=
-github.com/golang/lint v0.0.0-20180702182130-06c8688daad7/go.mod h1:tluoj9z5200jBnyusfRPU2LqT6J+DAorxEvtC7LHB+E=
-github.com/golang/mock v1.1.1/go.mod h1:oTYuIxOrZwtPieC+H1uAHpcLFnEyAGVDL/k47Jfbm0A=
-github.com/golang/mock v1.2.0/go.mod h1:oTYuIxOrZwtPieC+H1uAHpcLFnEyAGVDL/k47Jfbm0A=
 github.com/golang/mock v1.7.0-rc.1 h1:YojYx61/OLFsiv6Rw1Z96LpldJIy31o+UHmwAUMJ6/U=
 github.com/golang/mock v1.7.0-rc.1/go.mod h1:s42URUywIqd+OcERslBJvOjepvNymP31m3q8d/GkuRs=
-github.com/golang/protobuf v1.2.0/go.mod h1:6lQm79b+lXiMfvg/cZm0SGofjICqVBUtrP5yJMmIC1U=
-github.com/golang/protobuf v1.3.1/go.mod h1:6lQm79b+lXiMfvg/cZm0SGofjICqVBUtrP5yJMmIC1U=
-github.com/google/btree v0.0.0-20180813153112-4030bb1f1f0c/go.mod h1:lNA+9X1NB3Zf8V7Ke586lFgjr2dZNuvo3lPJSGZ5JPQ=
+github.com/golang/protobuf v1.5.4 h1:i7eJL8qZTpSEXOPTxNKhASYpMn+8e5Q6AdndVa1dWek=
+github.com/golang/protobuf v1.5.4/go.mod h1:lnTiLA8Wa4RWRcIUkrtSVa5nRhsEGBg48fD6rSs7xps=
 github.com/google/btree v1.1.2 h1:xf4v41cLI2Z6FxbKm+8Bu+m8ifhj15JuZ9sa0jZCMUU=
 github.com/google/btree v1.1.2/go.mod h1:qOPhT0dTNdNzV6Z/lhRX0YXUafgPLFUh+gZMl761Gm4=
-github.com/google/go-cmp v0.2.0/go.mod h1:oXzfMopK8JAjlY9xF4vHSVASa0yLyX7SntLO5aqRK0M=
-github.com/google/go-cmp v0.6.0 h1:ofyhxvXcZhMsU5ulbFiLKl/XBFqE1GSq7atu8tAmTRI=
-github.com/google/go-cmp v0.6.0/go.mod h1:17dUlkBOakJ0+DkrSSNjCkIjxS6bF9zb3elmeNGIjoY=
-github.com/google/go-github v17.0.0+incompatible/go.mod h1:zLgOLi98H3fifZn+44m+umXrS52loVEgC2AApnigrVQ=
-github.com/google/go-querystring v1.0.0/go.mod h1:odCYkC5MyYFN7vkCjXpyrEuKhc/BUO6wN/zVPAxq5ck=
-github.com/google/martian v2.1.0+incompatible/go.mod h1:9I4somxYTbIHy5NJKHRl3wXiIaQGbYVAs8BPL6v8lEs=
-github.com/google/pprof v0.0.0-20181206194817-3ea8567a2e57/go.mod h1:zfwlbNMJ+OItoe0UupaVj+oy1omPYYDuagoSzA8v9mc=
+github.com/google/go-cmp v0.7.0 h1:wk8382ETsv4JYUZwIsn6YpYiWiBsYLSJiTsyBybVuN8=
+github.com/google/go-cmp v0.7.0/go.mod h1:pXiqmnSA92OHEEa9HXL2W4E7lf9JzCmGVUdgjX3N/iU=
 github.com/google/pprof v0.0.0-20240528025155-186aa0362fba h1:ql1qNgCyOB7iAEk8JTNM+zJrgIbnyCKX/wdlyPufP5g=
 github.com/google/pprof v0.0.0-20240528025155-186aa0362fba/go.mod h1:K1liHPHnj73Fdn/EKuT8nrFqBihUSKXoLYU0BuatOYo=
 github.com/google/uuid v1.2.0/go.mod h1:TIyPZe4MgqvfeYDBFedMoGGpEw/LqOeaOT+nhxU+yHo=
 github.com/google/uuid v1.6.0 h1:NIvaJDMOsjHA8n1jAhLSgzrAzy1Hgr+hNrb57e+94F0=
 github.com/google/uuid v1.6.0/go.mod h1:TIyPZe4MgqvfeYDBFedMoGGpEw/LqOeaOT+nhxU+yHo=
-github.com/googleapis/gax-go v2.0.0+incompatible/go.mod h1:SFVmujtThgffbyetf+mdk2eWhX2bMyUtNHzFKcPA9HY=
-github.com/googleapis/gax-go/v2 v2.0.3/go.mod h1:LLvjysVCY1JZeum8Z6l8qUty8fiNwE08qbEPm1M08qg=
-github.com/gopherjs/gopherjs v0.0.0-20181017120253-0766667cb4d1/go.mod h1:wJfORRmW1u3UXTncJ5qlYoELFm8eSnnEO6hX4iZ3EWY=
 github.com/gorilla/websocket v1.5.3 h1:saDtZ6Pbx/0u+bgYQ3q96pZgCzfhKXGPqt7kZ72aNNg=
 github.com/gorilla/websocket v1.5.3/go.mod h1:YR8l580nyteQvAITg2hZ9XVh4b55+EU/adAjf1fMHhE=
-github.com/gregjones/httpcache v0.0.0-20180305231024-9cad4c3443a7/go.mod h1:FecbI9+v66THATjSRHfNgh1IVFe/9kFxbXtjV0ctIMA=
-github.com/grpc-ecosystem/grpc-gateway v1.5.0/go.mod h1:RSKVYQBd5MCa4OVpNdGskqpgL2+G+NZTnrVHpWWfpdw=
 github.com/hashicorp/go-cleanhttp v0.5.2 h1:035FKYIWjmULyFRBKPs8TBQoi0x6d9G4xc9neXJWAZQ=
 github.com/hashicorp/go-cleanhttp v0.5.2/go.mod h1:kO/YDlP8L1346E6Sodw+PrpBSV4/SoxCXGY6BqNFT48=
 github.com/hashicorp/go-envparse v0.1.0 h1:bE++6bhIsNCPLvgDZkYqo3nA+/PFI51pkrHdmPSDFPY=
@@ -136,27 +94,19 @@ github.com/hodgesds/perf-utils v0.7.0 h1:7KlHGMuig4FRH5fNw68PV6xLmgTe7jKs9hgAcEA
 github.com/hodgesds/perf-utils v0.7.0/go.mod h1:LAklqfDadNKpkxoAJNHpD5tkY0rkZEVdnCEWN5k4QJY=
 github.com/illumos/go-kstat v0.0.0-20210513183136-173c9b0a9973 h1:hk4LPqXIY/c9XzRbe7dA6qQxaT6Axcbny0L/G5a4owQ=
 github.com/illumos/go-kstat v0.0.0-20210513183136-173c9b0a9973/go.mod h1:PoK3ejP3LJkGTzKqRlpvCIFas3ncU02v8zzWDW+g0FY=
-github.com/jellevandenhooff/dkim v0.0.0-20150330215556-f50fe3d243e1/go.mod h1:E0B/fFc00Y+Rasa88328GlI/XbtyysCtTHZS8h7IrBU=
 github.com/jessevdk/go-flags v1.4.0/go.mod h1:4FA24M0QyGHXBuZZK/XkWh8h0e1EYbRYJSGM75WSRxI=
 github.com/josharian/native v1.1.0 h1:uuaP0hAbW7Y4l0ZRQ6C9zfb7Mg1mbFKry/xzDAfmtLA=
 github.com/josharian/native v1.1.0/go.mod h1:7X/raswPFr05uY3HiLlYeyQntB6OO7E/d2Cu7qoaN2w=
 github.com/jsimonetti/rtnetlink v1.4.2 h1:Df9w9TZ3npHTyDn0Ev9e1uzmN2odmXd0QX+J5GTEn90=
 github.com/jsimonetti/rtnetlink v1.4.2/go.mod h1:92s6LJdE+1iOrw+F2/RO7LYI2Qd8pPpFNNUYW06gcoM=
-github.com/json-iterator/go v1.1.6/go.mod h1:+SdeFBvtyEkXs7REEP0seUULqWtbJapLOCVDaaPEHmU=
-github.com/jstemmer/go-junit-report v0.0.0-20190106144839-af01ea7f8024/go.mod h1:6v2b51hI/fHJwM22ozAgKL4VKDeJcHhJFhtBdhmNjmU=
 github.com/juju/ratelimit v1.0.2 h1:sRxmtRiajbvrcLQT7S+JbqU0ntsb9W2yhSdNN8tWfaI=
 github.com/juju/ratelimit v1.0.2/go.mod h1:qapgC/Gy+xNh9UxzV13HGGl/6UXNN+ct+vwSgWNm/qk=
-github.com/kisielk/gotool v1.0.0/go.mod h1:XhKaO+MFFWcvkIS/tQcRk01m1F5IRFswLeQ+oQHNcck=
 github.com/klauspost/compress v1.17.9 h1:6KIumPrER1LHsvBVuDa0r5xaG0Es51mhhB9BQB2qeMA=
 github.com/klauspost/compress v1.17.9/go.mod h1:Di0epgTjJY877eYKx5yC51cX2A2Vl2ibi7bDH9ttBbw=
 github.com/klauspost/cpuid/v2 v2.2.7 h1:ZWSB3igEs+d0qvnxR/ZBzXVmxkgt8DdzP6m9pfuVLDM=
 github.com/klauspost/cpuid/v2 v2.2.7/go.mod h1:Lcz8mBdAVJIBVzewtcLocK12l3Y+JytZYpaMropDUws=
-github.com/kr/pretty v0.1.0/go.mod h1:dAy3ld7l9f0ibDNOQOHHMYYIIbhfbHSm3C4ZsoJORNo=
 github.com/kr/pretty v0.3.1 h1:flRD4NNwYAUpkphVc1HcthR4KEIFJ65n8Mw5qdRn3LE=
 github.com/kr/pretty v0.3.1/go.mod h1:hoEshYVHaxMs3cyo3Yncou5ZscifuDolrwPKZanG3xk=
-github.com/kr/pty v1.1.1/go.mod h1:pFQYn66WHrOpPYNljwOMqo10TkYh1fy3cYio2l3bCsQ=
-github.com/kr/pty v1.1.3/go.mod h1:pFQYn66WHrOpPYNljwOMqo10TkYh1fy3cYio2l3bCsQ=
-github.com/kr/text v0.1.0/go.mod h1:4Jbv+DJW3UT/LiOwJeYQe1efqtUx/iVham/4vfdArNI=
 github.com/kr/text v0.2.0 h1:5Nx0Ya0ZqY2ygV366QzturHI13Jq95ApcVaJBhpS+AY=
 github.com/kr/text v0.2.0/go.mod h1:eLer722TekiGuMkidMxC/pM04lWEeraHUUmBw8l2grE=
 github.com/kylelemons/godebug v1.1.0 h1:RPNrshWIDI6G2gRW9EHilWtl7Z6Sb1BR0xunSBf0SNc=
@@ -169,8 +119,6 @@ github.com/logrusorgru/aurora v2.0.3+incompatible h1:tOpm7WcpBTn4fjmVfgpQq0EfczG
 github.com/logrusorgru/aurora v2.0.3+incompatible/go.mod h1:7rIyQOR62GCctdiQpZ/zOJlFyk6y+94wXzv6RNZgaR4=
 github.com/lufia/iostat v1.2.1 h1:tnCdZBIglgxD47RyD55kfWQcJMGzO+1QBziSQfesf2k=
 github.com/lufia/iostat v1.2.1/go.mod h1:rEPNA0xXgjHQjuI5Cy05sLlS2oRcSlWHRLrvh/AQ+Pg=
-github.com/lunixbochs/vtclean v1.0.0/go.mod h1:pHhQNgMf3btfWnGBVipUOjRYhoOsdGqdm/+2c2E2WMI=
-github.com/mailru/easyjson v0.0.0-20190312143242-1de009706dbe/go.mod h1:C1wdFJiN94OJF2b5HbByQZoLdCWB1Yqtg26g4irojpc=
 github.com/mattn/go-colorable v0.1.13 h1:fFA4WZxdEF4tXPZVKMLwD8oUnCTTo08duU7wxecdEvA=
 github.com/mattn/go-colorable v0.1.13/go.mod h1:7S9/ev0klgBDR4GtXTXX8a3vIGJpMovkB8vQcUbaXHg=
 github.com/mattn/go-isatty v0.0.16/go.mod h1:kYGgaQfpe5nmfYZH+SKPsOc2e4SrIfOl2e/yFXSvRLM=
@@ -178,7 +126,6 @@ github.com/mattn/go-isatty v0.0.20 h1:xfD0iDuEKnDkl03q4limB+vH+GxLEtL/jb4xVJSWWE
 github.com/mattn/go-isatty v0.0.20/go.mod h1:W+V8PltTTMOvKvAeJH7IuucS94S2C6jfK/D7dTCTo3Y=
 github.com/mattn/go-xmlrpc v0.0.3 h1:Y6WEMLEsqs3RviBrAa1/7qmbGB7DVD3brZIbqMbQdGY=
 github.com/mattn/go-xmlrpc v0.0.3/go.mod h1:mqc2dz7tP5x5BKlCahN/n+hs7OSZKJkS9JsHNBRlrxA=
-github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod h1:D8He9yQNgCq6Z5Ld7szi9bcBfOoFv/3dc6xSMkL2PC0=
 github.com/mdlayher/ethtool v0.1.0 h1:XAWHsmKhyPOo42qq/yTPb0eFBGUKKTR1rE0dVrWVQ0Y=
 github.com/mdlayher/ethtool v0.1.0/go.mod h1:fBMLn2UhfRGtcH5ZFjr+6GUiHEjZsItFD7fSn7jbZVQ=
 github.com/mdlayher/genetlink v1.3.2 h1:KdrNKe+CTu+IbZnm/GVUMXSqBBLqcGpRDa0xkQy56gw=
@@ -189,68 +136,52 @@ github.com/mdlayher/socket v0.5.1 h1:VZaqt6RkGkt2OE9l3GcC6nZkqD3xKeQLyfleW/uBcos
 github.com/mdlayher/socket v0.5.1/go.mod h1:TjPLHI1UgwEv5J1B5q0zTZq12A/6H7nKmtTanQE37IQ=
 github.com/mdlayher/wifi v0.2.0 h1:vwbVyu5MWTiFNvOmWdvIx9veBlMVnEasZ90PhUi1DYU=
 github.com/mdlayher/wifi v0.2.0/go.mod h1:yOfWhVZ4FFJxeHzAxDzt87Om9EkqqcCiY9Gi5gfSXwI=
-github.com/microcosm-cc/bluemonday v1.0.1/go.mod h1:hsXNsILzKxV+sX77C5b8FSuKF00vh2OMYv+xgHpAMF4=
-github.com/miekg/dns v1.1.61 h1:nLxbwF3XxhwVSm8g9Dghm9MHPaUZuqhPiGL+675ZmEs=
-github.com/miekg/dns v1.1.61/go.mod h1:mnAarhS3nWaW+NVP2wTkYVIZyHNJ098SJZUki3eykwQ=
-github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd/go.mod h1:6dJC0mAP4ikYIbvyc7fijjWJddQyLn8Ig3JB5CqoB9Q=
-github.com/modern-go/reflect2 v1.0.1/go.mod h1:bx2lNnkwVCuqBIxFjflWJWanXIb3RllmbCylyMrvgv0=
+github.com/miekg/dns v1.1.68 h1:jsSRkNozw7G/mnmXULynzMNIsgY2dHC8LO6U6Ij2JEA=
+github.com/miekg/dns v1.1.68/go.mod h1:fujopn7TB3Pu3JM69XaawiU0wqjpL9/8xGop5UrTPps=
 github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822 h1:C3w9PqII01/Oq1c1nUAm88MOHcQC9l5mIlSMApZMrHA=
 github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822/go.mod h1:+n7T8mK8HuQTcFwEeznm/DIxMOiR9yIdICNftLE1DvQ=
 github.com/ncruces/go-strftime v0.1.9 h1:bY0MQC28UADQmHmaF5dgpLmImcShSi2kHU9XLdhx/f4=
 github.com/ncruces/go-strftime v0.1.9/go.mod h1:Fwc5htZGVVkseilnfgOVb9mKy6w1naJmn9CehxcKcls=
-github.com/neelance/astrewrite v0.0.0-20160511093645-99348263ae86/go.mod h1:kHJEU3ofeGjhHklVoIGuVj85JJwZ6kWPaJwCIxgnFmo=
-github.com/neelance/sourcemap v0.0.0-20151028013722-8c68805598ab/go.mod h1:Qr6/a/Q4r9LP1IltGz7tA7iOK1WonHEYhu1HRBA7ZiM=
-github.com/onsi/ginkgo/v2 v2.19.0 h1:9Cnnf7UHo57Hy3k6/m5k3dRfGTMXGvxhHFvkDTCTpvA=
-github.com/onsi/ginkgo/v2 v2.19.0/go.mod h1:rlwLi9PilAFJ8jCg9UE1QP6VBpd6/xj3SRC0d6TU0To=
-github.com/onsi/gomega v1.33.1 h1:dsYjIxxSR755MDmKVsaFQTE22ChNBcuuTWgkUDSubOk=
-github.com/onsi/gomega v1.33.1/go.mod h1:U4R44UsT+9eLIaYRB2a5qajjtQYn0hauxvRm16AVYg0=
 github.com/opencontainers/selinux v1.11.0 h1:+5Zbo97w3Lbmb3PeqQtpmTkMwsW5nRI3YaLpt7tQ7oU=
 github.com/opencontainers/selinux v1.11.0/go.mod h1:E5dMC3VPuVvVHDYmi78qvhJp8+M586T4DlDRYpFkyec=
-github.com/openzipkin/zipkin-go v0.1.1/go.mod h1:NtoC/o8u3JlF1lSlyPNswIbeQH9bJTmOf0Erfk+hxe8=
 github.com/oschwald/maxminddb-golang v1.12.0 h1:9FnTOD0YOhP7DGxGsq4glzpGy5+w7pq50AS6wALUMYs=
 github.com/oschwald/maxminddb-golang v1.12.0/go.mod h1:q0Nob5lTCqyQ8WT6FYgS1L7PXKVVbgiymefNwIjPzgY=
 github.com/pelletier/go-toml v1.9.5 h1:4yBQzkHv+7BHq2PQUZF3Mx0IYxG7LsP222s7Agd3ve8=
 github.com/pelletier/go-toml v1.9.5/go.mod h1:u1nR/EPcESfeI/szUZKdtJ0xRNbUoANCkoOuaOx1Y+c=
 github.com/pingcap/errors v0.11.4 h1:lFuQV/oaUMGcD2tqt+01ROSmJs75VG1ToEOkZIZ4nE4=
 github.com/pingcap/errors v0.11.4/go.mod h1:Oi8TUi2kEtXXLMJk9l1cGmz20kV3TaQ0usTwv5KuLY8=
-github.com/pires/go-proxyproto v0.7.0 h1:IukmRewDQFWC7kfnb66CSomk2q/seBuilHBYFwyq0Hs=
-github.com/pires/go-proxyproto v0.7.0/go.mod h1:Vz/1JPY/OACxWGQNIRY2BeyDmpoaWmEP40O9LbuiFR4=
-github.com/pkg/errors v0.8.1/go.mod h1:bwawxfHBFNV+L2hUp1rHADufV3IMtnDRdf1r5NINEl0=
+github.com/pires/go-proxyproto v0.8.1 h1:9KEixbdJfhrbtjpz/ZwCdWDD2Xem0NZ38qMYaASJgp0=
+github.com/pires/go-proxyproto v0.8.1/go.mod h1:ZKAAyp3cgy5Y5Mo4n9AlScrkCZwUy0g3Jf+slqQVcuU=
 github.com/pkg/errors v0.9.1 h1:FEBLx1zS214owpjy7qsBeixbURkuhQAwrK5UwLGTwt4=
 github.com/pkg/errors v0.9.1/go.mod h1:bwawxfHBFNV+L2hUp1rHADufV3IMtnDRdf1r5NINEl0=
 github.com/pmezard/go-difflib v1.0.0 h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM=
 github.com/pmezard/go-difflib v1.0.0/go.mod h1:iKH77koFhYxTK1pcRnkKkqfTogsbg7gZNVY4sRDYZ/4=
 github.com/prometheus-community/go-runit v0.1.0 h1:uTWEj/Fn2RoLdfg/etSqwzgYNOYPrARx1BHUN052tGA=
 github.com/prometheus-community/go-runit v0.1.0/go.mod h1:AvJ9Jo3gAFu2lbM4+qfjdpq30FfiLDJZKbQ015u08IQ=
-github.com/prometheus/client_golang v0.8.0/go.mod h1:7SWBe2y4D6OKWSNQJUaRYU/AaXPKyh/dDVn+NZz0KFw=
 github.com/prometheus/client_golang v1.20.0 h1:jBzTZ7B099Rg24tny+qngoynol8LtVYlA2bqx3vEloI=
 github.com/prometheus/client_golang v1.20.0/go.mod h1:PIEt8X02hGcP8JWbeHyeZ53Y/jReSnHgO035n//V5WE=
-github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod h1:MbSGuTsp3dbXC40dX6PRTWyKYBIrTGTE9sqQNg2J8bo=
 github.com/prometheus/client_model v0.6.1 h1:ZKSh/rekM+n3CeS952MLRAdFwIKqeY8b62p8ais2e9E=
 github.com/prometheus/client_model v0.6.1/go.mod h1:OrxVMOVHjw3lKMa8+x6HeMGkHMQyHDk9E3jmP2AmGiY=
-github.com/prometheus/common v0.0.0-20180801064454-c7de2306084e/go.mod h1:daVV7qP5qjZbuso7PdcryaAu0sAZbrN9i7WWcTMWvro=
 github.com/prometheus/common v0.55.0 h1:KEi6DK7lXW/m7Ig5i47x0vRzuBsHuvJdi5ee6Y3G1dc=
 github.com/prometheus/common v0.55.0/go.mod h1:2SECS4xJG1kd8XF9IcM1gMX6510RAEL65zxzNImwdc8=
 github.com/prometheus/node_exporter v1.8.2 h1:G8NryhgftPSXTnD+DuaNZTHDqmHF3zLWgPeG5RUtcHg=
 github.com/prometheus/node_exporter v1.8.2/go.mod h1:rJMoAQMglUjAZ7nggHnRuwfJ0hKUVW6+Gv+IaMxh6js=
-github.com/prometheus/procfs v0.0.0-20180725123919-05ee40e3a273/go.mod h1:c3At6R/oaqEKCNdg8wHV1ftS6bRYblBhIjjI8uT2IGk=
 github.com/prometheus/procfs v0.15.1 h1:YagwOFzUgYfKKHX6Dr+sHT7km/hxC76UB0learggepc=
 github.com/prometheus/procfs v0.15.1/go.mod h1:fB45yRUv8NstnjriLhBQLuOUt+WW4BsoGhij/e3PBqk=
-github.com/quic-go/qpack v0.4.0 h1:Cr9BXA1sQS2SmDUWjSofMPNKmvF6IiIfDRmgU0w1ZCo=
-github.com/quic-go/qpack v0.4.0/go.mod h1:UZVnYIfi5GRk+zI9UMaCPsmZ2xKJP7XBUvVyT1Knj9A=
+github.com/quic-go/qpack v0.5.1 h1:giqksBPnT/HDtZ6VhtFKgoLOWmlyo9Ei6u9PqzIMbhI=
+github.com/quic-go/qpack v0.5.1/go.mod h1:+PC4XFrEskIVkcLzpEkbLqq1uCoxPhQuvK5rH1ZgaEg=
 github.com/quic-go/qtls-go1-20 v0.4.1 h1:D33340mCNDAIKBqXuAvexTNMUByrYmFYVfKfDN5nfFs=
 github.com/quic-go/qtls-go1-20 v0.4.1/go.mod h1:X9Nh97ZL80Z+bX/gUXMbipO6OxdiDi58b/fMC9mAL+k=
-github.com/quic-go/quic-go v0.45.1 h1:tPfeYCk+uZHjmDRwHHQmvHRYL2t44ROTujLeFVBmjCA=
-github.com/quic-go/quic-go v0.45.1/go.mod h1:1dLehS7TIR64+vxGR70GDcatWTOtMX2PUtnKsjbTurI=
-github.com/refraction-networking/utls v1.6.7 h1:zVJ7sP1dJx/WtVuITug3qYUq034cDq9B2MR1K67ULZM=
-github.com/refraction-networking/utls v1.6.7/go.mod h1:BC3O4vQzye5hqpmDTWUqi4P5DDhzJfkV1tdqtawQIH0=
+github.com/quic-go/quic-go v0.55.0 h1:zccPQIqYCXDt5NmcEabyYvOnomjs8Tlwl7tISjJh9Mk=
+github.com/quic-go/quic-go v0.55.0/go.mod h1:DR51ilwU1uE164KuWXhinFcKWGlEjzys2l8zUl5Ss1U=
+github.com/refraction-networking/utls v1.8.1 h1:yNY1kapmQU8JeM1sSw2H2asfTIwWxIkrMJI0pRUOCAo=
+github.com/refraction-networking/utls v1.8.1/go.mod h1:jkSOEkLqn+S/jtpEHPOsVv/4V4EVnelwbMQl4vCWXAM=
 github.com/remyoudompheng/bigfft v0.0.0-20230129092748-24d4a6f8daec h1:W09IVJc94icq4NjY3clb7Lk8O1qJ8BdBEF8z0ibU0rE=
 github.com/remyoudompheng/bigfft v0.0.0-20230129092748-24d4a6f8daec/go.mod h1:qqbHyh8v60DhA7CoWK5oRCqLrMHRGoxYCSS9EjAz6Eo=
 github.com/riobard/go-bloom v0.0.0-20200614022211-cdc8013cb5b3 h1:f/FNXud6gA3MNr8meMVVGxhp+QBTqY91tM8HjEuMjGg=
 github.com/riobard/go-bloom v0.0.0-20200614022211-cdc8013cb5b3/go.mod h1:HgjTstvQsPGkxUsCd2KWxErBblirPizecHcpD3ffK+s=
 github.com/rogpeppe/go-internal v1.10.0 h1:TMyTOH3F/DB16zRVcYyreMH6GnZZrwQVAoYjRBZyWFQ=
 github.com/rogpeppe/go-internal v1.10.0/go.mod h1:UQnix2H7Ngw/k4C5ijL5+65zddjncjaFoBhdsK/akog=
-github.com/russross/blackfriday v1.5.2/go.mod h1:JO/DiYxRf+HjHt06OyowR9PTA263kcR/rfWxYHBV53g=
 github.com/russross/blackfriday/v2 v2.1.0 h1:JIOH55/0cWyOuilr9/qlrm0BSXldqnqwMsf35Ld67mk=
 github.com/russross/blackfriday/v2 v2.1.0/go.mod h1:+Rmxgy9KzJVeS9/2gXHxylqXiyQDYRxCVz55jmeOWTM=
 github.com/safchain/ethtool v0.3.0 h1:gimQJpsI6sc1yIqP/y8GYgiXn/NjgvpM0RNoWLVVmP0=
@@ -261,8 +192,8 @@ github.com/sagernet/netlink v0.0.0-20240523065131-45e60152f9ba h1:EY5AS7CCtfmARN
 github.com/sagernet/netlink v0.0.0-20240523065131-45e60152f9ba/go.mod h1:xLnfdiJbSp8rNqYEdIW/6eDO4mVoogml14Bh2hSiFpM=
 github.com/sagernet/quic-go v0.46.0-beta.4 h1:k9f7VSKaM47AY6MPND0Qf1KRN7HwimPg9zdOFTXTiCk=
 github.com/sagernet/quic-go v0.46.0-beta.4/go.mod h1:zJmVdJUNqEDXfubf4KtIOUHHerggjBduiGRLNzJspcM=
-github.com/sagernet/sing v0.4.2 h1:jzGNJdZVRI0xlAfFugsIQUPvyB9SuWvbJK7zQCXc4QM=
-github.com/sagernet/sing v0.4.2/go.mod h1:ieZHA/+Y9YZfXs2I3WtuwgyCZ6GPsIR7HdKb1SdEnls=
+github.com/sagernet/sing v0.5.1 h1:mhL/MZVq0TjuvHcpYcFtmSD1BFOxZ/+8ofbNZcg1k1Y=
+github.com/sagernet/sing v0.5.1/go.mod h1:ARkL0gM13/Iv5VCZmci/NuoOlePoIsW0m7BWfln/Hak=
 github.com/sagernet/sing-box v1.9.4 h1:Sf2JffjKvcG2a2+YWPOP0NiCOqpu2iPU12RkpZ0PhaM=
 github.com/sagernet/sing-box v1.9.4/go.mod h1:DGX0xLYqlQa36DX1PTWJBh6EnChI1hUyzwoJUObhlW4=
 github.com/sagernet/sing-dns v0.2.3 h1:YzeBUn2tR38F7HtvGEQ0kLRLmZWMEgi/+7wqa4Twb1k=
@@ -273,41 +204,14 @@ github.com/sagernet/sing-tun v0.3.2 h1:z0bLUT/YXH9RrJS9DsIpB0Bb9afl2hVJOmHd0zA3H
 github.com/sagernet/sing-tun v0.3.2/go.mod h1:DxLIyhjWU/HwGYoX0vNGg2c5QgTQIakphU1MuERR5tQ=
 github.com/seiflotfy/cuckoofilter v0.0.0-20240715131351-a2f2c23f1771 h1:emzAzMZ1L9iaKCTxdy3Em8Wv4ChIAGnfiz18Cda70g4=
 github.com/seiflotfy/cuckoofilter v0.0.0-20240715131351-a2f2c23f1771/go.mod h1:bR6DqgcAl1zTcOX8/pE2Qkj9XO00eCNqmKb7lXP8EAg=
-github.com/sergi/go-diff v1.0.0/go.mod h1:0CfEIISq7TuYL3j771MWULgwwjU+GofnZX9QAmXWZgo=
-github.com/shurcooL/component v0.0.0-20170202220835-f88ec8f54cc4/go.mod h1:XhFIlyj5a1fBNx5aJTbKoIq0mNaPvOagO+HjB3EtxrY=
-github.com/shurcooL/events v0.0.0-20181021180414-410e4ca65f48/go.mod h1:5u70Mqkb5O5cxEA8nxTsgrgLehJeAw6Oc4Ab1c/P1HM=
-github.com/shurcooL/github_flavored_markdown v0.0.0-20181002035957-2122de532470/go.mod h1:2dOwnU2uBioM+SGy2aZoq1f/Sd1l9OkAeAUvjSyvgU0=
-github.com/shurcooL/go v0.0.0-20180423040247-9e1955d9fb6e/go.mod h1:TDJrrUr11Vxrven61rcy3hJMUqaf/CLWYhHNPmT14Lk=
-github.com/shurcooL/go-goon v0.0.0-20170922171312-37c2f522c041/go.mod h1:N5mDOmsrJOB+vfqUK+7DmDyjhSLIIBnXo9lvZJj3MWQ=
-github.com/shurcooL/gofontwoff v0.0.0-20180329035133-29b52fc0a18d/go.mod h1:05UtEgK5zq39gLST6uB0cf3NEHjETfB4Fgr3Gx5R9Vw=
-github.com/shurcooL/gopherjslib v0.0.0-20160914041154-feb6d3990c2c/go.mod h1:8d3azKNyqcHP1GaQE/c6dDgjkgSx2BZ4IoEi4F1reUI=
-github.com/shurcooL/highlight_diff v0.0.0-20170515013008-09bb4053de1b/go.mod h1:ZpfEhSmds4ytuByIcDnOLkTHGUI6KNqRNPDLHDk+mUU=
-github.com/shurcooL/highlight_go v0.0.0-20181028180052-98c3abbbae20/go.mod h1:UDKB5a1T23gOMUJrI+uSuH0VRDStOiUVSjBTRDVBVag=
-github.com/shurcooL/home v0.0.0-20181020052607-80b7ffcb30f9/go.mod h1:+rgNQw2P9ARFAs37qieuu7ohDNQ3gds9msbT2yn85sg=
-github.com/shurcooL/htmlg v0.0.0-20170918183704-d01228ac9e50/go.mod h1:zPn1wHpTIePGnXSHpsVPWEktKXHr6+SS6x/IKRb7cpw=
-github.com/shurcooL/httperror v0.0.0-20170206035902-86b7830d14cc/go.mod h1:aYMfkZ6DWSJPJ6c4Wwz3QtW22G7mf/PEgaB9k/ik5+Y=
-github.com/shurcooL/httpfs v0.0.0-20171119174359-809beceb2371/go.mod h1:ZY1cvUeJuFPAdZ/B6v7RHavJWZn2YPVFQ1OSXhCGOkg=
-github.com/shurcooL/httpgzip v0.0.0-20180522190206-b1c53ac65af9/go.mod h1:919LwcH0M7/W4fcZ0/jy0qGght1GIhqyS/EgWGH2j5Q=
-github.com/shurcooL/issues v0.0.0-20181008053335-6292fdc1e191/go.mod h1:e2qWDig5bLteJ4fwvDAc2NHzqFEthkqn7aOZAOpj+PQ=
-github.com/shurcooL/issuesapp v0.0.0-20180602232740-048589ce2241/go.mod h1:NPpHK2TI7iSaM0buivtFUc9offApnI0Alt/K8hcHy0I=
-github.com/shurcooL/notifications v0.0.0-20181007000457-627ab5aea122/go.mod h1:b5uSkrEVM1jQUspwbixRBhaIjIzL2xazXp6kntxYle0=
-github.com/shurcooL/octicon v0.0.0-20181028054416-fa4f57f9efb2/go.mod h1:eWdoE5JD4R5UVWDucdOPg1g2fqQRq78IQa9zlOV1vpQ=
-github.com/shurcooL/reactions v0.0.0-20181006231557-f2e0b4ca5b82/go.mod h1:TCR1lToEk4d2s07G3XGfz2QrgHXg4RJBvjrOozvoWfk=
-github.com/shurcooL/sanitized_anchor_name v0.0.0-20170918181015-86672fcb3f95/go.mod h1:1NzhyTcUVG4SuEtjjoZeVRXNmyL/1OwPU0+IJeTBvfc=
-github.com/shurcooL/users v0.0.0-20180125191416-49c67e49c537/go.mod h1:QJTqeLYEDaXHZDBsXlPCDqdhQuJkuw4NOtaxYe3xii4=
-github.com/shurcooL/webdavfs v0.0.0-20170829043945-18c3829fa133/go.mod h1:hKmq5kWdCj2z2KEozexVbfEZIWiTjhE0+UjmZgPqehw=
 github.com/siebenmann/go-kstat v0.0.0-20210513183136-173c9b0a9973 h1:GfSdC6wKfTGcgCS7BtzF5694Amne1pGCSTY252WhlEY=
 github.com/siebenmann/go-kstat v0.0.0-20210513183136-173c9b0a9973/go.mod h1:G81aIFAMS9ECrwBYR9YxhlPjWgrItd+Kje78O6+uqm8=
-github.com/sourcegraph/annotate v0.0.0-20160123013949-f4cad6c6324d/go.mod h1:UdhH50NIW0fCiwBSr0co2m7BnFLdv4fQTgdqdJTHFeE=
-github.com/sourcegraph/syntaxhighlight v0.0.0-20170531221838-bd320f5d308e/go.mod h1:HuIsMU8RRBOtsCgI77wP899iHVBQpCmg4ErYMZB+2IA=
 github.com/stretchr/objx v0.1.0/go.mod h1:HFkY916IF+rwdDfMAkV7OtwuqBVzrE8GR6GFx+wExME=
-github.com/stretchr/testify v1.2.2/go.mod h1:a8OnRcib4nhh0OaRAV+Yts87kKdq0PP7pXfy6kDkUVs=
 github.com/stretchr/testify v1.3.0/go.mod h1:M5WIy9Dh21IEIfnGCwXGc5bZfKNJtfHm1UVUgZn+9EI=
 github.com/stretchr/testify v1.4.0/go.mod h1:j7eGeouHqKxXV5pUuKE4zz7dFj8WfuZ+81PSLYec5m4=
 github.com/stretchr/testify v1.6.1/go.mod h1:6Fq8oRcR53rry900zMqJjRRixrwX3KX962/h/Wwjteg=
-github.com/stretchr/testify v1.9.0 h1:HtqpIVDClZ4nwg75+f6Lvsy/wHu+3BoSGCbBAcpTsTg=
-github.com/stretchr/testify v1.9.0/go.mod h1:r2ic/lqez/lEtzL7wO/rwa5dbSLXVDPFyf8C91i36aY=
-github.com/tarm/serial v0.0.0-20180830185346-98f6abe2eb07/go.mod h1:kDXzergiv9cbyO7IOYJZWg1U88JhDg3PB6klq9Hg2pA=
+github.com/stretchr/testify v1.11.1 h1:7s2iGBzp5EwR7/aIZr8ao5+dra3wiQyKjjFuvgVKu7U=
+github.com/stretchr/testify v1.11.1/go.mod h1:wZwfW3scLgRK+23gO65QZefKpKQRnfz6sD981Nm4B6U=
 github.com/urfave/cli/v2 v2.27.4 h1:o1owoI+02Eb+K107p27wEX9Bb8eqIoZCfLXloLUSWJ8=
 github.com/urfave/cli/v2 v2.27.4/go.mod h1:m4QzxcD2qpra4z7WhzEGn74WZLViBnMpb1ToCAKdGRQ=
 github.com/v2fly/ss-bloomring v0.0.0-20210312155135-28617310f63e h1:5QefA066A1tF8gHIiADmOVOV5LS43gt3ONnlEl3xkwI=
@@ -316,139 +220,92 @@ github.com/valyala/bytebufferpool v1.0.0 h1:GqA5TC/0021Y/b9FG4Oi9Mr3q7XYx6Kllzaw
 github.com/valyala/bytebufferpool v1.0.0/go.mod h1:6bBcMArwyJ5K/AmCkWv1jt77kVWyCJ6HpOuEn7z0Csc=
 github.com/valyala/fasttemplate v1.2.2 h1:lxLXG0uE3Qnshl9QyaK6XJxMXlQZELvChBOCmQD0Loo=
 github.com/valyala/fasttemplate v1.2.2/go.mod h1:KHLXt3tVN2HBp8eijSv/kGJopbvo7S+qRAEEKiv+SiQ=
-github.com/viant/assertly v0.4.8/go.mod h1:aGifi++jvCrUaklKEKT0BU95igDNaqkvz+49uaYMPRU=
-github.com/viant/toolbox v0.24.0/go.mod h1:OxMCG57V0PXuIP2HNQrtJf2CjqdmbrOx5EkMILuUhzM=
-github.com/vishvananda/netlink v1.2.1-beta.2.0.20230316163032-ced5aaba43e3 h1:tkMT5pTye+1NlKIXETU78NXw0fyjnaNHmJyyLyzw8+U=
-github.com/vishvananda/netlink v1.2.1-beta.2.0.20230316163032-ced5aaba43e3/go.mod h1:cAAsePK2e15YDAMJNyOpGYEWNe4sIghTY7gpz4cX/Ik=
-github.com/vishvananda/netns v0.0.0-20200728191858-db3c7e526aae/go.mod h1:DD4vA1DwXk04H54A1oHXtwZmA0grkVMdPxx/VGLCah0=
-github.com/vishvananda/netns v0.0.4 h1:Oeaw1EM2JMxD51g9uhtC0D7erkIjgmj8+JZc26m1YX8=
-github.com/vishvananda/netns v0.0.4/go.mod h1:SpkAiCQRtJ6TvvxPnOSyH3BMl6unz3xZlaprSwhNNJM=
+github.com/vishvananda/netlink v1.3.1 h1:3AEMt62VKqz90r0tmNhog0r/PpWKmrEShJU0wJW6bV0=
+github.com/vishvananda/netlink v1.3.1/go.mod h1:ARtKouGSTGchR8aMwmkzC0qiNPrrWO5JS/XMVl45+b4=
+github.com/vishvananda/netns v0.0.5 h1:DfiHV+j8bA32MFM7bfEunvT8IAqQ/NzSJHtcmW5zdEY=
+github.com/vishvananda/netns v0.0.5/go.mod h1:SpkAiCQRtJ6TvvxPnOSyH3BMl6unz3xZlaprSwhNNJM=
 github.com/xhit/go-str2duration/v2 v2.1.0 h1:lxklc02Drh6ynqX+DdPyp5pCKLUQpRT8bp8Ydu2Bstc=
 github.com/xhit/go-str2duration/v2 v2.1.0/go.mod h1:ohY8p+0f07DiV6Em5LKB0s2YpLtXVyJfNt1+BlmyAsU=
 github.com/xrash/smetrics v0.0.0-20240521201337-686a1a2994c1 h1:gEOO8jv9F4OT7lGCjxCBTO/36wtF6j2nSip77qHd4x4=
 github.com/xrash/smetrics v0.0.0-20240521201337-686a1a2994c1/go.mod h1:Ohn+xnUBiLI6FVj/9LpzZWtj1/D6lUovWYBkxHVV3aM=
-github.com/xtls/reality v0.0.0-20240712055506-48f0b2d5ed6d h1:+B97uD9uHLgAAulhigmys4BVwZZypzK7gPN3WtpgRJg=
-github.com/xtls/reality v0.0.0-20240712055506-48f0b2d5ed6d/go.mod h1:dm4y/1QwzjGaK17ofi0Vs6NpKAHegZky8qk6J2JJZAE=
-github.com/xtls/xray-core v1.8.23 h1:A8Wr50ildMYLpaNu3EiK+Stg/tps6i0h7z5Hr4f9H2k=
-github.com/xtls/xray-core v1.8.23/go.mod h1:0CwyMPNA5Cs+ukPXHbYQGgne/ug0PuXOSVqBu7zyXOc=
-go.opencensus.io v0.18.0/go.mod h1:vKdFvxhtzZ9onBp9VKHK8z/sRpBMnKAsufL7wlDrCOA=
+github.com/xtls/reality v0.0.0-20251014195629-e4eec4520535 h1:nwobseOLLRtdbP6z7Z2aVI97u8ZptTgD1ofovhAKmeU=
+github.com/xtls/reality v0.0.0-20251014195629-e4eec4520535/go.mod h1:vbHCV/3VWUvy1oKvTxxWJRPEWSeR1sYgQHIh6u/JiZQ=
+github.com/xtls/xray-core v1.251015.0 h1:P7b3vt8ShhH31k4h6VJ/Pxar3tY9eK+7S8eygd6rsP0=
+github.com/xtls/xray-core v1.251015.0/go.mod h1:72ZU/srfutsNPmw9y8SCGRy0iccvshIRk8BNGR8D2Ik=
+go.opentelemetry.io/auto/sdk v1.1.0 h1:cH53jehLUN6UFLY71z+NDOiNJqDdPRaXzTel0sJySYA=
+go.opentelemetry.io/auto/sdk v1.1.0/go.mod h1:3wSPjt5PWp2RhlCcmmOial7AvC4DQqZb7a7wCow3W8A=
+go.opentelemetry.io/otel v1.37.0 h1:9zhNfelUvx0KBfu/gb+ZgeAfAgtWrfHJZcAqFC228wQ=
+go.opentelemetry.io/otel v1.37.0/go.mod h1:ehE/umFRLnuLa/vSccNq9oS1ErUlkkK71gMcN34UG8I=
+go.opentelemetry.io/otel/metric v1.37.0 h1:mvwbQS5m0tbmqML4NqK+e3aDiO02vsf/WgbsdpcPoZE=
+go.opentelemetry.io/otel/metric v1.37.0/go.mod h1:04wGrZurHYKOc+RKeye86GwKiTb9FKm1WHtO+4EVr2E=
+go.opentelemetry.io/otel/sdk v1.37.0 h1:ItB0QUqnjesGRvNcmAcU0LyvkVyGJ2xftD29bWdDvKI=
+go.opentelemetry.io/otel/sdk v1.37.0/go.mod h1:VredYzxUvuo2q3WRcDnKDjbdvmO0sCzOvVAiY+yUkAg=
+go.opentelemetry.io/otel/sdk/metric v1.37.0 h1:90lI228XrB9jCMuSdA0673aubgRobVZFhbjxHHspCPc=
+go.opentelemetry.io/otel/sdk/metric v1.37.0/go.mod h1:cNen4ZWfiD37l5NhS+Keb5RXVWZWpRE+9WyVCpbo5ps=
+go.opentelemetry.io/otel/trace v1.37.0 h1:HLdcFNbRQBE2imdSEgm/kwqmQj1Or1l/7bW6mxVK7z4=
+go.opentelemetry.io/otel/trace v1.37.0/go.mod h1:TlgrlQ+PtQO5XFerSPUYG0JSgGyryXewPGyayAWSBS0=
 go.uber.org/atomic v1.7.0/go.mod h1:fEN4uk6kAWBTFdckzkM89CLk9XfWZrxpCo0nPH17wJc=
 go.uber.org/atomic v1.11.0 h1:ZvwS0R+56ePWxUNi+Atn9dWONBPp/AUETXlHW0DxSjE=
 go.uber.org/atomic v1.11.0/go.mod h1:LUxbIzbOniOlMKjJjyPfpl4v+PKK2cNJn91OQbhoJI0=
 go.uber.org/goleak v1.3.0 h1:2K3zAYmnTNqV73imy9J1T3WC+gmCePx2hEGkimedGto=
 go.uber.org/goleak v1.3.0/go.mod h1:CoHD4mav9JJNrW/WLlf7HGZPjdw8EucARQHekz1X6bE=
-go.uber.org/mock v0.4.0 h1:VcM4ZOtdbR4f6VXfiOpwpVJDL6lCReaZ6mw31wqh7KU=
-go.uber.org/mock v0.4.0/go.mod h1:a6FSlNadKUHUa9IP5Vyt1zh4fC7uAwxMutEAscFbkZc=
+go.uber.org/mock v0.5.2 h1:LbtPTcP8A5k9WPXj54PPPbjcI4Y6lhyOZXn+VS7wNko=
+go.uber.org/mock v0.5.2/go.mod h1:wLlUxC2vVTPTaE3UD51E0BGOAElKrILxhVSDYQLld5o=
 go.uber.org/multierr v1.6.0/go.mod h1:cdWPpRnG4AhwMwsgIHip0KRBQjJy5kYEpYjJxpXp9iU=
 go.uber.org/multierr v1.11.0 h1:blXXJkSxSSfBVBlC76pxqeO+LN3aDfLQo+309xJstO0=
 go.uber.org/multierr v1.11.0/go.mod h1:20+QtiLqy0Nd6FdQB9TLXag12DsQkrbs3htMFfDN80Y=
 go.uber.org/zap v1.27.0 h1:aJMhYGrd5QSmlpLMr2MftRKl7t8J8PTZPA732ud/XR8=
 go.uber.org/zap v1.27.0/go.mod h1:GB2qFLM7cTU87MWRP2mPIjqfIDnGu+VIO4V/SdhGo2E=
-go4.org v0.0.0-20180809161055-417644f6feb5/go.mod h1:MkTOUMDaeVYJUOUsaDXIhWPZYa1yOyC1qaOBpL57BhE=
 go4.org/netipx v0.0.0-20231129151722-fdeea329fbba h1:0b9z3AuHCjxk0x/opv64kcgZLBseWJUpBw5I82+2U4M=
 go4.org/netipx v0.0.0-20231129151722-fdeea329fbba/go.mod h1:PLyyIXexvUFg3Owu6p/WfdlivPbZJsZdgWZlrGope/Y=
-golang.org/x/build v0.0.0-20190111050920-041ab4dc3f9d/go.mod h1:OWs+y06UdEOHN4y+MfF/py+xQ/tYqIWW03b70/CG9Rw=
-golang.org/x/crypto v0.0.0-20181030102418-4d3f4d9ffa16/go.mod h1:6SG95UA2DQfeDnfUPMdvaQW0Q7yPrPDi9nlGo2tz2b4=
-golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod h1:djNgcEr1/C05ACkg1iLfiJU5Ep61QUkGW8qpdssI0+w=
-golang.org/x/crypto v0.0.0-20190313024323-a1f597ede03a/go.mod h1:djNgcEr1/C05ACkg1iLfiJU5Ep61QUkGW8qpdssI0+w=
-golang.org/x/crypto v0.25.0 h1:ypSNr+bnYL2YhwoMt2zPxHFmbAN1KZs/njMG3hxUp30=
-golang.org/x/crypto v0.25.0/go.mod h1:T+wALwcMOSE0kXgUAnPAHqTLW+XHgcELELW8VaDgm/M=
-golang.org/x/exp v0.0.0-20190121172915-509febef88a4/go.mod h1:CJ0aWSM057203Lf6IL+f9T1iT9GByDxfZKAQTCR3kQA=
+golang.org/x/crypto v0.43.0 h1:dduJYIi3A3KOfdGOHX8AVZ/jGiyPa3IbBozJ5kNuE04=
+golang.org/x/crypto v0.43.0/go.mod h1:BFbav4mRNlXJL4wNeejLpWxB7wMbc79PdRGhWKncxR0=
 golang.org/x/exp v0.0.0-20240531132922-fd00a4e0eefc h1:O9NuF4s+E/PvMIy+9IUZB9znFwUIXEWSstNjek6VpVg=
 golang.org/x/exp v0.0.0-20240531132922-fd00a4e0eefc/go.mod h1:XtvwrStGgqGPLc4cjQfWqZHG1YFdYs6swckp8vpsjnc=
-golang.org/x/lint v0.0.0-20180702182130-06c8688daad7/go.mod h1:UVdnD1Gm6xHRNCYTkRU2/jEulfH38KcIWyp/GAMgvoE=
-golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod h1:UVdnD1Gm6xHRNCYTkRU2/jEulfH38KcIWyp/GAMgvoE=
-golang.org/x/lint v0.0.0-20190227174305-5b3e6a55c961/go.mod h1:wehouNa3lNwaWXcvxsM5YxQ5yQlVC4a0KAMCusXpPoU=
-golang.org/x/mod v0.18.0 h1:5+9lSbEzPSdWkH32vYPBwEpX8KwDbM52Ud9xBUvNlb0=
-golang.org/x/mod v0.18.0/go.mod h1:hTbmBsO62+eylJbnUtE2MGJUyE7QWk4xUqPFrRgJ+7c=
-golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod h1:mL1N/T3taQHkDXs73rZJwtUhF3w3ftmwwsq0BUmARs4=
-golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod h1:mL1N/T3taQHkDXs73rZJwtUhF3w3ftmwwsq0BUmARs4=
-golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod h1:mL1N/T3taQHkDXs73rZJwtUhF3w3ftmwwsq0BUmARs4=
-golang.org/x/net v0.0.0-20181029044818-c44066c5c816/go.mod h1:mL1N/T3taQHkDXs73rZJwtUhF3w3ftmwwsq0BUmARs4=
-golang.org/x/net v0.0.0-20181106065722-10aee1819953/go.mod h1:mL1N/T3taQHkDXs73rZJwtUhF3w3ftmwwsq0BUmARs4=
-golang.org/x/net v0.0.0-20190108225652-1e06a53dbb7e/go.mod h1:mL1N/T3taQHkDXs73rZJwtUhF3w3ftmwwsq0BUmARs4=
-golang.org/x/net v0.0.0-20190213061140-3a22650c66bd/go.mod h1:mL1N/T3taQHkDXs73rZJwtUhF3w3ftmwwsq0BUmARs4=
-golang.org/x/net v0.0.0-20190313220215-9f648a60d977/go.mod h1:t9HGtf8HONx5eT2rtn7q6eTqICYqUVnKs3thJo3Qplg=
+golang.org/x/mod v0.28.0 h1:gQBtGhjxykdjY9YhZpSlZIsbnaE2+PgjfLWUQTnoZ1U=
+golang.org/x/mod v0.28.0/go.mod h1:yfB/L0NOf/kmEbXjzCPOx1iK1fRutOydrCMsqRhEBxI=
 golang.org/x/net v0.0.0-20210316092652-d523dce5a7f4/go.mod h1:RBQZq4jEuRlivfhVLdyRGr576XBO4/greRjx4P4O3yc=
-golang.org/x/net v0.27.0 h1:5K3Njcw06/l2y9vpGCSdcxWOYHOUk3dVNGDXN+FvAys=
-golang.org/x/net v0.27.0/go.mod h1:dDi0PyhWNoiUOrAS8uXv/vnScO4wnHQO4mj9fn/RytE=
-golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod h1:N/0e6XlmueqKjAGxoOufVs8QHGRruUQn6yWY3a++T0U=
-golang.org/x/oauth2 v0.0.0-20181017192945-9dcd33a902f4/go.mod h1:N/0e6XlmueqKjAGxoOufVs8QHGRruUQn6yWY3a++T0U=
-golang.org/x/oauth2 v0.0.0-20181203162652-d668ce993890/go.mod h1:N/0e6XlmueqKjAGxoOufVs8QHGRruUQn6yWY3a++T0U=
-golang.org/x/oauth2 v0.0.0-20190226205417-e64efc72b421/go.mod h1:gOpvHmFTYa4IltrdGE7lF6nIHvwfUNPOp7c8zoXwtLw=
-golang.org/x/perf v0.0.0-20180704124530-6e6d33e29852/go.mod h1:JLpeXjPJfIyPr5TlbXLkXWLhP8nz10XfvxElABhCtcw=
-golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM=
-golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM=
-golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM=
-golang.org/x/sync v0.0.0-20190227155943-e225da77a7e6/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM=
+golang.org/x/net v0.46.0 h1:giFlY12I07fugqwPuWJi68oOnpfqFnJIJzaIIm2JVV4=
+golang.org/x/net v0.46.0/go.mod h1:Q9BGdFy1y4nkUwiLvT5qtyhAnEHgnQ/zd8PfU6nc210=
 golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM=
-golang.org/x/sync v0.8.0 h1:3NFvSEYkUoMifnESzZl15y791HH1qU2xm6eCJU5ZPXQ=
-golang.org/x/sync v0.8.0/go.mod h1:Czt+wKu1gCyEFDUtn0jG5QVvpJ6rzVqr5aXyt9drQfk=
-golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY=
-golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY=
-golang.org/x/sys v0.0.0-20181029174526-d69651ed3497/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY=
-golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY=
-golang.org/x/sys v0.0.0-20190316082340-a2f829d7f35f/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
-golang.org/x/sys v0.0.0-20200217220822-9197077df867/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
+golang.org/x/sync v0.17.0 h1:l60nONMj9l5drqw6jlhIELNv9I0A4OFgRsG9k2oT9Ug=
+golang.org/x/sync v0.17.0/go.mod h1:9KTHXmSnoGruLpwFjVSX0lNNA75CykiMECbovNTZqGI=
 golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20210315160823-c6e025ad8005/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20211031064116-611d5d643895/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
-golang.org/x/sys v0.0.0-20220804214406-8e32c043e418/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
 golang.org/x/sys v0.0.0-20220811171246-fbc7d0a398ab/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
 golang.org/x/sys v0.1.0/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
+golang.org/x/sys v0.2.0/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
 golang.org/x/sys v0.5.0/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
 golang.org/x/sys v0.6.0/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
-golang.org/x/sys v0.22.0 h1:RI27ohtqKCnwULzJLqkv897zojh5/DwS/ENaMzUOaWI=
-golang.org/x/sys v0.22.0/go.mod h1:/VUhepiaJMQUp4+oa/7Zr1D23ma6VTLIYjOOTFZPUcA=
+golang.org/x/sys v0.10.0/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
+golang.org/x/sys v0.37.0 h1:fdNQudmxPjkdUTPnLn5mdQv7Zwvbvpaxqs831goi9kQ=
+golang.org/x/sys v0.37.0/go.mod h1:OgkHotnGiDImocRcuBABYBEXf8A9a87e/uXjp9XT3ks=
 golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod h1:bj7SfCRtBDWHUb9snDiAeCFNEtKQo2Wmx5Cou7ajbmo=
-golang.org/x/text v0.3.0/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
-golang.org/x/text v0.3.1-0.20180807135948-17ff2d5776d2/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
 golang.org/x/text v0.3.3/go.mod h1:5Zoc/QRtKVWzQhOtBMvqHzDpF6irO9z98xDceosuGiQ=
-golang.org/x/text v0.16.0 h1:a94ExnEXNtEwYLGJSIUxnWoxoRz/ZcCsV63ROupILh4=
-golang.org/x/text v0.16.0/go.mod h1:GhwF1Be+LQoKShO3cGOHzqOgRrGaYc9AvblQOmPVHnI=
-golang.org/x/time v0.0.0-20180412165947-fbb02b2291d2/go.mod h1:tRJNPiyCQ0inRvYxbN9jk5I+vvW/OXSQhTDSoE431IQ=
-golang.org/x/time v0.0.0-20181108054448-85acf8d2951c/go.mod h1:tRJNPiyCQ0inRvYxbN9jk5I+vvW/OXSQhTDSoE431IQ=
-golang.org/x/time v0.6.0 h1:eTDhh4ZXt5Qf0augr54TN6suAUudPcawVZeIAPU7D4U=
-golang.org/x/time v0.6.0/go.mod h1:3BpzKBy/shNhVucY/MWOyx10tF3SFh9QdLuxbVysPQM=
-golang.org/x/tools v0.0.0-20180828015842-6cd1fcedba52/go.mod h1:n7NCudcB/nEzxVGmLbDWY5pfWTLqBcC2KZ6jyYvM4mQ=
+golang.org/x/text v0.30.0 h1:yznKA/E9zq54KzlzBEAWn1NXSQ8DIp/NYMy88xJjl4k=
+golang.org/x/text v0.30.0/go.mod h1:yDdHFIX9t+tORqspjENWgzaCVXgk0yYnYuSZ8UzzBVM=
+golang.org/x/time v0.7.0 h1:ntUhktv3OPE6TgYxXWv9vKvUSJyIFJlyohwbkEwPrKQ=
+golang.org/x/time v0.7.0/go.mod h1:3BpzKBy/shNhVucY/MWOyx10tF3SFh9QdLuxbVysPQM=
 golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod h1:n7NCudcB/nEzxVGmLbDWY5pfWTLqBcC2KZ6jyYvM4mQ=
-golang.org/x/tools v0.0.0-20181030000716-a0a13e073c7b/go.mod h1:n7NCudcB/nEzxVGmLbDWY5pfWTLqBcC2KZ6jyYvM4mQ=
-golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod h1:n7NCudcB/nEzxVGmLbDWY5pfWTLqBcC2KZ6jyYvM4mQ=
-golang.org/x/tools v0.0.0-20190226205152-f727befe758c/go.mod h1:9Yl7xja0Znq3iFh3HoIrodX9oNMXvdceNzlUR8zjMvY=
-golang.org/x/tools v0.22.0 h1:gqSGLZqv+AI9lIQzniJ0nZDRG5GBPsSi+DRNHWNz6yA=
-golang.org/x/tools v0.22.0/go.mod h1:aCwcsjqvq7Yqt6TNyX7QMU2enbQ/Gt0bo6krSeEri+c=
+golang.org/x/tools v0.37.0 h1:DVSRzp7FwePZW356yEAChSdNcQo6Nsp+fex1SUW09lE=
+golang.org/x/tools v0.37.0/go.mod h1:MBN5QPQtLMHVdvsbtarmTNukZDdgwdwlO5qGacAzF0w=
 golang.zx2c4.com/wintun v0.0.0-20230126152724-0fa3db229ce2 h1:B82qJJgjvYKsXS9jeunTOisW56dUokqW/FOteYJJ/yg=
 golang.zx2c4.com/wintun v0.0.0-20230126152724-0fa3db229ce2/go.mod h1:deeaetjYA+DHMHg+sMSMI58GrEteJUUzzw7en6TJQcI=
 golang.zx2c4.com/wireguard v0.0.0-20231211153847-12269c276173 h1:/jFs0duh4rdb8uIfPMv78iAJGcPKDeqAFnaLBropIC4=
 golang.zx2c4.com/wireguard v0.0.0-20231211153847-12269c276173/go.mod h1:tkCQ4FQXmpAgYVh++1cq16/dH4QJtmvpRv19DWGAHSA=
-google.golang.org/api v0.0.0-20180910000450-7ca32eb868bf/go.mod h1:4mhQ8q/RsB7i+udVvVy5NUi08OU8ZlA0gRVgrF7VFY0=
-google.golang.org/api v0.0.0-20181030000543-1d582fd0359e/go.mod h1:4mhQ8q/RsB7i+udVvVy5NUi08OU8ZlA0gRVgrF7VFY0=
-google.golang.org/api v0.1.0/go.mod h1:UGEZY7KEX120AnNLIHFMKIo4obdJhkp2tPbaPlQx13Y=
-google.golang.org/appengine v1.1.0/go.mod h1:EbEs0AVv82hx2wNQdGPgUI5lhzA/G0D9YwlJXL52JkM=
-google.golang.org/appengine v1.2.0/go.mod h1:xpcJRLb0r/rnEns0DIKYYv+WjYCduHsrkT7/EB5XEv4=
-google.golang.org/appengine v1.3.0/go.mod h1:xpcJRLb0r/rnEns0DIKYYv+WjYCduHsrkT7/EB5XEv4=
-google.golang.org/appengine v1.4.0/go.mod h1:xpcJRLb0r/rnEns0DIKYYv+WjYCduHsrkT7/EB5XEv4=
-google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod h1:JiN7NxoALGmiZfu7CAH4rXhgtRTLTxftemlI0sWmxmc=
-google.golang.org/genproto v0.0.0-20180831171423-11092d34479b/go.mod h1:JiN7NxoALGmiZfu7CAH4rXhgtRTLTxftemlI0sWmxmc=
-google.golang.org/genproto v0.0.0-20181029155118-b69ba1387ce2/go.mod h1:JiN7NxoALGmiZfu7CAH4rXhgtRTLTxftemlI0sWmxmc=
-google.golang.org/genproto v0.0.0-20181202183823-bd91e49a0898/go.mod h1:7Ep/1NZk928CDR8SjdVbjWNpdIf6nzjE3BTgJDr2Atg=
-google.golang.org/genproto v0.0.0-20190306203927-b5d61aea6440/go.mod h1:VzzqZJRnGkLBvHegQrXjBqPurQTc5/KpmUdxsrq26oE=
-google.golang.org/genproto/googleapis/rpc v0.0.0-20240528184218-531527333157 h1:Zy9XzmMEflZ/MAaA7vNcoebnRAld7FsPW1EeBB7V0m8=
-google.golang.org/genproto/googleapis/rpc v0.0.0-20240528184218-531527333157/go.mod h1:EfXuqaE1J41VCDicxHzUDm+8rk+7ZdXzHV0IhO/I6s0=
-google.golang.org/grpc v1.14.0/go.mod h1:yo6s7OP7yaDglbqo1J04qKzAhqBH6lvTonzMVmEdcZw=
-google.golang.org/grpc v1.16.0/go.mod h1:0JHn/cJsOMiMfNA9+DeHDlAU7KAAB5GDlYFpa9MZMio=
-google.golang.org/grpc v1.17.0/go.mod h1:6QZJwpn2B+Zp71q/5VxRsJ6NXXVCE5NRUHRo+f3cWCs=
-google.golang.org/grpc v1.19.0/go.mod h1:mqu4LbDTu4XGKhr4mRzUsmM4RtVoemTSY81AxZiDr8c=
-google.golang.org/grpc v1.65.0 h1:bs/cUb4lp1G5iImFFd3u5ixQzweKizoZJAwBNLR42lc=
-google.golang.org/grpc v1.65.0/go.mod h1:WgYC2ypjlB0EiQi6wdKixMqukr6lBc0Vo+oOgjrM5ZQ=
-google.golang.org/protobuf v1.34.2 h1:6xV6lTsCfpGD21XK49h7MhtcApnLqkfYgPcdHftf6hg=
-google.golang.org/protobuf v1.34.2/go.mod h1:qYOHts0dSfpeUzUFpOMr/WGzszTmLH+DiWniOlNbLDw=
+gonum.org/v1/gonum v0.16.0 h1:5+ul4Swaf3ESvrOnidPp4GZbzf0mxVQpDCYUQE7OJfk=
+gonum.org/v1/gonum v0.16.0/go.mod h1:fef3am4MQ93R2HHpKnLk4/Tbh/s0+wqD5nfa6Pnwy4E=
+google.golang.org/genproto/googleapis/rpc v0.0.0-20250804133106-a7a43d27e69b h1:zPKJod4w6F1+nRGDI9ubnXYhU9NSWoFAijkHkUXeTK8=
+google.golang.org/genproto/googleapis/rpc v0.0.0-20250804133106-a7a43d27e69b/go.mod h1:qQ0YXyHHx3XkvlzUtpXDkS29lDSafHMZBAZDc03LQ3A=
+google.golang.org/grpc v1.76.0 h1:UnVkv1+uMLYXoIz6o7chp59WfQUYA2ex/BXQ9rHZu7A=
+google.golang.org/grpc v1.76.0/go.mod h1:Ju12QI8M6iQJtbcsV+awF5a4hfJMLi4X0JLo94ULZ6c=
+google.golang.org/protobuf v1.36.10 h1:AYd7cD/uASjIL6Q9LiTjz8JLcrh/88q5UObnmY3aOOE=
+google.golang.org/protobuf v1.36.10/go.mod h1:HTf+CrKn2C3g5S8VImy6tdcUvCska2kB7j23XfzDpco=
 gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod h1:Co6ibVJAznAaIkqp8huTwlJQCZ016jof/cbN4VW5Yz0=
 gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c h1:Hei/4ADfdWqJk1ZMxUNpqntNwaWcugrBjAiHlqqRiVk=
 gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c/go.mod h1:JHkPIbrfpd72SG/EVd6muEfDQjcINNoR0C8j2r3qZ4Q=
-gopkg.in/inf.v0 v0.9.1/go.mod h1:cWUDdTG/fYaXco+Dcufb5Vnc6Gp2YChqWtbxRZE0mXw=
 gopkg.in/yaml.v1 v1.0.0-20140924161607-9f9df34309c0/go.mod h1:WDnlLJ4WF5VGsH/HVa3CI79GS0ol3YnhVnKP89i0kNg=
-gopkg.in/yaml.v2 v2.2.1/go.mod h1:hI93XBmqTisBFMUTm0b8Fm+jr3Dg1NNxqwp+5A1VGuI=
 gopkg.in/yaml.v2 v2.2.2/go.mod h1:hI93XBmqTisBFMUTm0b8Fm+jr3Dg1NNxqwp+5A1VGuI=
 gopkg.in/yaml.v2 v2.4.0 h1:D8xgwECY7CYvx+Y2n4sBz93Jn9JRvxdiyyo8CTfuKaY=
 gopkg.in/yaml.v2 v2.4.0/go.mod h1:RDklbk79AGWmwhnvt/jBztapEOGDOx6ZbXqjP6csGnQ=
@@ -456,16 +313,12 @@ gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod h1:K4uyk7z7BCEPqu6E+C
 gopkg.in/yaml.v3 v3.0.0-20200605160147-a5ece683394c/go.mod h1:K4uyk7z7BCEPqu6E+C64Yfv1cQ7kz7rIZviUmN+EgEM=
 gopkg.in/yaml.v3 v3.0.1 h1:fxVm/GzAzEWqLHuvctI91KS9hhNmmWOoWu0XTYJS7CA=
 gopkg.in/yaml.v3 v3.0.1/go.mod h1:K4uyk7z7BCEPqu6E+C64Yfv1cQ7kz7rIZviUmN+EgEM=
-grpc.go4.org v0.0.0-20170609214715-11d0a25b4919/go.mod h1:77eQGdRu53HpSqPFJFmuJdjuHRquDANNeA4x7B8WQ9o=
-gvisor.dev/gvisor v0.0.0-20231202080848-1f7806d17489 h1:ze1vwAdliUAr68RQ5NtufWaXaOg8WUO2OACzEV+TNdE=
-gvisor.dev/gvisor v0.0.0-20231202080848-1f7806d17489/go.mod h1:10sU+Uh5KKNv1+2x2A0Gvzt8FjD3ASIhorV3YsauXhk=
-honnef.co/go/tools v0.0.0-20180728063816-88497007e858/go.mod h1:rf3lG4BRIbNafJWhAfAdb/ePZxsR/4RtNHQocxwk9r4=
-honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod h1:rf3lG4BRIbNafJWhAfAdb/ePZxsR/4RtNHQocxwk9r4=
-honnef.co/go/tools v0.0.0-20190106161140-3f1c8253044a/go.mod h1:rf3lG4BRIbNafJWhAfAdb/ePZxsR/4RtNHQocxwk9r4=
+gvisor.dev/gvisor v0.0.0-20250428193742-2d800c3129d5 h1:sfK5nHuG7lRFZ2FdTT3RimOqWBg8IrVm+/Vko1FVOsk=
+gvisor.dev/gvisor v0.0.0-20250428193742-2d800c3129d5/go.mod h1:3r5CMtNQMKIvBlrmM9xWUNamjKBYPOWyXOjmg5Kts3g=
 howett.net/plist v1.0.1 h1:37GdZ8tP09Q35o9ych3ehygcsL+HqKSwzctveSlarvM=
 howett.net/plist v1.0.1/go.mod h1:lqaXoTrLY4hg8tnEzNru53gicrbv7rrk+2xJA/7hw9g=
-lukechampine.com/blake3 v1.3.0 h1:sJ3XhFINmHSrYCgl958hscfIa3bw8x4DqMP3u1YvoYE=
-lukechampine.com/blake3 v1.3.0/go.mod h1:0OFRp7fBtAylGVCO40o87sbupkyIGgbpv1+M1k1LM6k=
+lukechampine.com/blake3 v1.4.1 h1:I3Smz7gso8w4/TunLKec6K2fn+kyKtDxr/xcQEN84Wg=
+lukechampine.com/blake3 v1.4.1/go.mod h1:QFosUxmjB8mnrWFSNwKmvxHpfY72bmD2tQ0kBMM3kwo=
 modernc.org/cc/v4 v4.21.4 h1:3Be/Rdo1fpr8GrQ7IVw9OHtplU4gWbb+wNgeoBMmGLQ=
 modernc.org/cc/v4 v4.21.4/go.mod h1:HM7VJTZbUCR3rV8EYBi9wxnJ0ZBRiGE5OeGXNA0IsLQ=
 modernc.org/ccgo/v4 v4.19.2 h1:lwQZgvboKD0jBwdaeVCTouxhxAyN6iawF3STraAal8Y=
@@ -492,5 +345,3 @@ modernc.org/strutil v1.2.0 h1:agBi9dp1I+eOnxXeiZawM8F4LawKv4NzGWSaLfyeNZA=
 modernc.org/strutil v1.2.0/go.mod h1:/mdcBmfOibveCTBxUl5B5l6W+TTH1FXPLHZE6bTosX0=
 modernc.org/token v1.1.0 h1:Xl7Ap9dKaEs5kLoOQeQmPWevfnk/DM5qcLcYlA8ys6Y=
 modernc.org/token v1.1.0/go.mod h1:UGzOrNV1mAFSEB63lOFHIpNRUVMvYTc6yu1SMY/XTDM=
-sourcegraph.com/sourcegraph/go-diff v0.5.0/go.mod h1:kuch7UrkMzY0X+p9CRK03kfuPQ2zzQcaEFbx8wA8rck=
-sourcegraph.com/sqs/pbtypes v0.0.0-20180604144634-d3ebe8f20ae4/go.mod h1:ketZ/q3QxT9HOBeFhu6RdvsftgpsbFHBF5Cas6cDKZ0=
