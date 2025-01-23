class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.7.5.tar.gz"
  sha256 "4d2271227ea63c5cce6a656dd16057022479c5c4acdf966ca0246f461bdce061"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74315348892d925634239ab2e791b2901d1e1fa1bed08ccd1782c4d09f4e62e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74315348892d925634239ab2e791b2901d1e1fa1bed08ccd1782c4d09f4e62e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74315348892d925634239ab2e791b2901d1e1fa1bed08ccd1782c4d09f4e62e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "09901a91078dc39a58a2b99241b9393108e98689d96209f4867432d64a5ac931"
    sha256 cellar: :any_skip_relocation, ventura:       "09901a91078dc39a58a2b99241b9393108e98689d96209f4867432d64a5ac931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87b113afd8240357f276f559ab9eaef84f42277e763bb1b68c76472ad86f6821"
  end

  depends_on "go" => :build

  # bump to use go1.23, upstream patch PR, https://github.com/zeromicro/go-zero/pull/4279
  patch :DATA

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath/"api/main.tpl", :exist?, "goctl install fail"
  end
end

__END__
diff --git a/tools/goctl/go.mod b/tools/goctl/go.mod
index 44fa301..d497f99 100644
--- a/tools/goctl/go.mod
+++ b/tools/goctl/go.mod
@@ -1,6 +1,6 @@
 module github.com/zeromicro/go-zero/tools/goctl
 
-go 1.20
+go 1.23
 
 require (
 	github.com/DATA-DOG/go-sqlmock v1.5.2
diff --git a/tools/goctl/go.sum b/tools/goctl/go.sum
index e06be84..a28c6d7 100644
--- a/tools/goctl/go.sum
+++ b/tools/goctl/go.sum
@@ -9,10 +9,13 @@ github.com/alicebob/miniredis/v2 v2.33.0/go.mod h1:MhP4a3EU7aENRi9aO+tHfTBZicLqQ
 github.com/antlr/antlr4/runtime/Go/antlr v0.0.0-20210521184019-c5ad59b459ec h1:EEyRvzmpEUZ+I8WmD5cw/vY8EqhambkOqy5iFr0908A=
 github.com/antlr/antlr4/runtime/Go/antlr v0.0.0-20210521184019-c5ad59b459ec/go.mod h1:F7bn7fEU90QkQ3tnmaTx3LTKLEDqnwWODIYppRQ5hnY=
 github.com/benbjohnson/clock v1.1.0 h1:Q92kusRqC1XV2MjkWETPvjJVqKetz1OzxZB7mHJLju8=
+github.com/benbjohnson/clock v1.1.0/go.mod h1:J11/hYXuz8f4ySSvYwY0FKfm+ezbsZBKZxNJlLklBHA=
 github.com/beorn7/perks v1.0.1 h1:VlbKKnNfV8bJzeqoa4cOKqO6bYr3WgKZxO8Z16+hsOM=
 github.com/beorn7/perks v1.0.1/go.mod h1:G2ZrVWU2WbWT9wwq4/hrbKbnv/1ERSJQ0ibhJ6rlkpw=
 github.com/bsm/ginkgo/v2 v2.12.0 h1:Ny8MWAHyOepLGlLKYmXG4IEkioBysk6GpaRTLC8zwWs=
+github.com/bsm/ginkgo/v2 v2.12.0/go.mod h1:SwYbGRRDovPVboqFv0tPTcG1sN61LM1Z4ARdbAV9g4c=
 github.com/bsm/gomega v1.27.10 h1:yeMWxP2pV2fG3FgAODIY8EiRE3dy0aeFYt4l7wh6yKA=
+github.com/bsm/gomega v1.27.10/go.mod h1:JyEr/xRbxbtgWNi8tIEVPUYZ5Dzef52k01W3YH0H+O0=
 github.com/cenkalti/backoff/v4 v4.3.0 h1:MyRJ/UdXutAwSAT+s3wNd7MfTIcy71VQueUuFK343L8=
 github.com/cenkalti/backoff/v4 v4.3.0/go.mod h1:Y3VNntkOUPxTVeUxJ/G5vcM//AlwfmyYozVcomhLiZE=
 github.com/cespare/xxhash/v2 v2.3.0 h1:UL815xU9SqsFlibzuggzjXhog7bL6oX9BbNZnL2UFvs=
@@ -52,6 +55,7 @@ github.com/go-openapi/swag v0.22.4/go.mod h1:UzaqsxGiab7freDnrUUra0MwWfN/q7tE4j+
 github.com/go-sql-driver/mysql v1.8.1 h1:LedoTUt/eveggdHS9qUFC1EFSa8bU2+1pZjSRpvNJ1Y=
 github.com/go-sql-driver/mysql v1.8.1/go.mod h1:wEBSXgmK//2ZFJyE+qWnIsVGmvmEKlqwuVSjsCm7DZg=
 github.com/go-task/slim-sprig v0.0.0-20230315185526-52ccab3ef572 h1:tfuBGBXKqDEevZMzYi5KSi8KkcZtzBcTgAUUtapy0OI=
+github.com/go-task/slim-sprig v0.0.0-20230315185526-52ccab3ef572/go.mod h1:9Pwr4B2jHnOSGXyyzV8ROjYa2ojvAY6HCGYYfMoC3Ls=
 github.com/godbus/dbus/v5 v5.0.4/go.mod h1:xhWf0FNVPg57R7Z0UbKHbJfkEywrmjJnf7w5xrFpKfA=
 github.com/gogo/protobuf v1.3.2 h1:Ov1cvc58UF3b5XjBnZv7+opcTcQFZebYjWzi34vdm4Q=
 github.com/gogo/protobuf v1.3.2/go.mod h1:P1XiOD3dCwIKUDQYPy72D8LYyHL2YPYrpS2s69NZV8Q=
@@ -68,6 +72,7 @@ github.com/google/gofuzz v1.0.0/go.mod h1:dBl0BpW6vV/+mYPU4Po3pmUjxk6FQPldtuIdl/
 github.com/google/gofuzz v1.2.0 h1:xRy4A+RhZaiKjJ1bPfwQ8sedCA+YS2YcCHW6ec7JMi0=
 github.com/google/gofuzz v1.2.0/go.mod h1:dBl0BpW6vV/+mYPU4Po3pmUjxk6FQPldtuIdl/M65Eg=
 github.com/google/pprof v0.0.0-20210720184732-4bb14d4b1be1 h1:K6RDEckDVWvDI9JAJYCmNdQXq6neHJOYx3V6jnqNEec=
+github.com/google/pprof v0.0.0-20210720184732-4bb14d4b1be1/go.mod h1:kpwsk12EmLew5upagYY7GY0pfYCcupk39gWOCRROcvE=
 github.com/google/uuid v1.6.0 h1:NIvaJDMOsjHA8n1jAhLSgzrAzy1Hgr+hNrb57e+94F0=
 github.com/google/uuid v1.6.0/go.mod h1:TIyPZe4MgqvfeYDBFedMoGGpEw/LqOeaOT+nhxU+yHo=
 github.com/gookit/color v1.5.4 h1:FZmqs7XOyGgCAxmWyPslpiok1k05wmY3SJTytgvYFs0=
@@ -75,6 +80,7 @@ github.com/gookit/color v1.5.4/go.mod h1:pZJOeOS8DM43rXbp4AZo1n9zCU2qjpcRko0b6/Q
 github.com/grpc-ecosystem/grpc-gateway/v2 v2.20.0 h1:bkypFPDjIYGfCYD5mRBvpqxfYX1YCS1PXdKYWi8FsN0=
 github.com/grpc-ecosystem/grpc-gateway/v2 v2.20.0/go.mod h1:P+Lt/0by1T8bfcF3z737NnSbmxQAppXMRziHUxPOC8k=
 github.com/h2non/parth v0.0.0-20190131123155-b4df798d6542 h1:2VTzZjLZBgl62/EtslCrtky5vbi9dd7HrQPQIx6wqiw=
+github.com/h2non/parth v0.0.0-20190131123155-b4df798d6542/go.mod h1:Ow0tF8D4Kplbc8s8sSb3V2oUCygFHVp8gC3Dn6U4MNI=
 github.com/iancoleman/strcase v0.3.0 h1:nTXanmYxhfFAMjZL34Ov6gkzEsSJZ5DbhxWjvSASxEI=
 github.com/iancoleman/strcase v0.3.0/go.mod h1:iwCmte+B7n89clKwxIoIXy/HfoL7AsD47ZCWhYzw7ho=
 github.com/inconshreveable/mousetrap v1.1.0 h1:wN+x4NVGpMsO7ErUn/mUI3vEoE6Jt13X2s0bqwp9tc8=
@@ -98,11 +104,13 @@ github.com/klauspost/compress v1.17.9 h1:6KIumPrER1LHsvBVuDa0r5xaG0Es51mhhB9BQB2
 github.com/klauspost/compress v1.17.9/go.mod h1:Di0epgTjJY877eYKx5yC51cX2A2Vl2ibi7bDH9ttBbw=
 github.com/kr/pretty v0.2.1/go.mod h1:ipq/a2n7PKx3OHsz4KJII5eveXtPO4qwEXGdVfWzfnI=
 github.com/kr/pretty v0.3.1 h1:flRD4NNwYAUpkphVc1HcthR4KEIFJ65n8Mw5qdRn3LE=
+github.com/kr/pretty v0.3.1/go.mod h1:hoEshYVHaxMs3cyo3Yncou5ZscifuDolrwPKZanG3xk=
 github.com/kr/pty v1.1.1/go.mod h1:pFQYn66WHrOpPYNljwOMqo10TkYh1fy3cYio2l3bCsQ=
 github.com/kr/text v0.1.0/go.mod h1:4Jbv+DJW3UT/LiOwJeYQe1efqtUx/iVham/4vfdArNI=
 github.com/kr/text v0.2.0 h1:5Nx0Ya0ZqY2ygV366QzturHI13Jq95ApcVaJBhpS+AY=
 github.com/kr/text v0.2.0/go.mod h1:eLer722TekiGuMkidMxC/pM04lWEeraHUUmBw8l2grE=
 github.com/kylelemons/godebug v1.1.0 h1:RPNrshWIDI6G2gRW9EHilWtl7Z6Sb1BR0xunSBf0SNc=
+github.com/kylelemons/godebug v1.1.0/go.mod h1:9/0rRGxNHcop5bhtWyNeEfOS8JIWk580+fNqagV/RAw=
 github.com/logrusorgru/aurora v2.0.3+incompatible h1:tOpm7WcpBTn4fjmVfgpQq0EfczGlG91VSDkswnjF5A8=
 github.com/logrusorgru/aurora v2.0.3+incompatible/go.mod h1:7rIyQOR62GCctdiQpZ/zOJlFyk6y+94wXzv6RNZgaR4=
 github.com/mailru/easyjson v0.7.7 h1:UGYAvKxe3sBsEDzO8ZeWOSlIQfWFlxbzLZe7hwFURr0=
@@ -120,15 +128,19 @@ github.com/modern-go/reflect2 v1.0.2/go.mod h1:yWuevngMOJpCy52FWWMvUC8ws7m/LJsjY
 github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822 h1:C3w9PqII01/Oq1c1nUAm88MOHcQC9l5mIlSMApZMrHA=
 github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822/go.mod h1:+n7T8mK8HuQTcFwEeznm/DIxMOiR9yIdICNftLE1DvQ=
 github.com/onsi/ginkgo/v2 v2.13.0 h1:0jY9lJquiL8fcf3M4LAXN5aMlS/b2BV86HFFPCPMgE4=
+github.com/onsi/ginkgo/v2 v2.13.0/go.mod h1:TE309ZR8s5FsKKpuB1YAQYBzCaAfUgatB/xlT/ETL/o=
 github.com/onsi/gomega v1.29.0 h1:KIA/t2t5UBzoirT4H9tsML45GEbo3ouUnBHsCfD2tVg=
+github.com/onsi/gomega v1.29.0/go.mod h1:9sxs+SwGrKI0+PWe4Fxa9tFQQBG5xSsSbMXOI8PPpoQ=
 github.com/openzipkin/zipkin-go v0.4.3 h1:9EGwpqkgnwdEIJ+Od7QVSEIH+ocmm5nPat0G7sjsSdg=
 github.com/openzipkin/zipkin-go v0.4.3/go.mod h1:M9wCJZFWCo2RiY+o1eBCEMe0Dp2S5LDHcMZmk3RmK7c=
 github.com/pelletier/go-toml/v2 v2.2.2 h1:aYUidT7k73Pcl9nb2gScu7NSrKCSHIDE89b3+6Wq+LM=
 github.com/pelletier/go-toml/v2 v2.2.2/go.mod h1:1t835xjRzz80PqgE6HHgN2JOsmgYu/h4qDAS4n929Rs=
 github.com/pkg/errors v0.9.1 h1:FEBLx1zS214owpjy7qsBeixbURkuhQAwrK5UwLGTwt4=
+github.com/pkg/errors v0.9.1/go.mod h1:bwawxfHBFNV+L2hUp1rHADufV3IMtnDRdf1r5NINEl0=
 github.com/pmezard/go-difflib v1.0.0 h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM=
 github.com/pmezard/go-difflib v1.0.0/go.mod h1:iKH77koFhYxTK1pcRnkKkqfTogsbg7gZNVY4sRDYZ/4=
 github.com/prashantv/gostub v1.1.0 h1:BTyx3RfQjRHnUWaGF9oQos79AlQ5k8WNktv7VGvVH4g=
+github.com/prashantv/gostub v1.1.0/go.mod h1:A5zLQHz7ieHGG7is6LLXLz7I8+3LZzsrV0P1IAHhP5U=
 github.com/prometheus/client_golang v1.20.5 h1:cxppBPuYhUnsO6yo/aoRol4L7q7UFfdm+bR9r+8l63Y=
 github.com/prometheus/client_golang v1.20.5/go.mod h1:PIEt8X02hGcP8JWbeHyeZ53Y/jReSnHgO035n//V5WE=
 github.com/prometheus/client_model v0.6.1 h1:ZKSh/rekM+n3CeS952MLRAdFwIKqeY8b62p8ais2e9E=
@@ -140,6 +152,7 @@ github.com/prometheus/procfs v0.15.1/go.mod h1:fB45yRUv8NstnjriLhBQLuOUt+WW4BsoG
 github.com/redis/go-redis/v9 v9.7.0 h1:HhLSs+B6O021gwzl+locl0zEDnyNkxMtf/Z3NNBMa9E=
 github.com/redis/go-redis/v9 v9.7.0/go.mod h1:f6zhXITC7JUJIlPEiBOTXxJgPLdZcA93GewI7inzyWw=
 github.com/rogpeppe/go-internal v1.10.0 h1:TMyTOH3F/DB16zRVcYyreMH6GnZZrwQVAoYjRBZyWFQ=
+github.com/rogpeppe/go-internal v1.10.0/go.mod h1:UQnix2H7Ngw/k4C5ijL5+65zddjncjaFoBhdsK/akog=
 github.com/russross/blackfriday/v2 v2.1.0/go.mod h1:+Rmxgy9KzJVeS9/2gXHxylqXiyQDYRxCVz55jmeOWTM=
 github.com/spaolacci/murmur3 v1.1.0 h1:7c1g84S4BPRrfL5Xrdp6fOJ206sU9y293DDHaoy0bLI=
 github.com/spaolacci/murmur3 v1.1.0/go.mod h1:JwIasOWyU6f++ZhiEuf87xNszmSA2myDM2Kzu9HwQUA=
@@ -208,6 +221,7 @@ go.uber.org/atomic v1.10.0/go.mod h1:LUxbIzbOniOlMKjJjyPfpl4v+PKK2cNJn91OQbhoJI0
 go.uber.org/automaxprocs v1.6.0 h1:O3y2/QNTOdbF+e/dpXNNW7Rx2hZ4sTIPyybbxyNqTUs=
 go.uber.org/automaxprocs v1.6.0/go.mod h1:ifeIMSnPZuznNm6jmdzmU3/bfk01Fe2fotchwEFJ8r8=
 go.uber.org/goleak v1.3.0 h1:2K3zAYmnTNqV73imy9J1T3WC+gmCePx2hEGkimedGto=
+go.uber.org/goleak v1.3.0/go.mod h1:CoHD4mav9JJNrW/WLlf7HGZPjdw8EucARQHekz1X6bE=
 go.uber.org/multierr v1.9.0 h1:7fIwc/ZtS0q++VgcfqFDxSBZVv/Xo49/SYnDFupUwlI=
 go.uber.org/multierr v1.9.0/go.mod h1:X2jQV1h+kxSjClGpnseKVIxpmcjrj7MNnI0bnlfKTVQ=
 go.uber.org/zap v1.24.0 h1:FiJd5l1UOLj0wCgbSE0rwwXHzEdAZS6hiiSnxJN/D60=
@@ -260,6 +274,7 @@ golang.org/x/tools v0.0.0-20200619180055-7c47624df98f/go.mod h1:EkVYQZoAsY45+roY
 golang.org/x/tools v0.0.0-20210106214847-113979e3529a/go.mod h1:emZCQorbCU4vsT4fOWvOPXz4eW1wZW4PmDk9uLelYpA=
 golang.org/x/tools v0.1.1/go.mod h1:o0xws9oXOQQZyjljx8fwUC0k7L1pTE6eaCbjGeHmOkk=
 golang.org/x/tools v0.21.1-0.20240508182429-e35e4ccd0d2d h1:vU5i/LfpvrRCpgM/VPfJLg5KjxD3E+hfT1SH+d9zLwg=
+golang.org/x/tools v0.21.1-0.20240508182429-e35e4ccd0d2d/go.mod h1:aiJjzUbINMkxbQROHiO6hDPo2LHcIPhhQsa9DLh0yGk=
 golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
 golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
 golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
@@ -276,6 +291,7 @@ gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod h1:Co6ibVJAznAaIkqp8
 gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c h1:Hei/4ADfdWqJk1ZMxUNpqntNwaWcugrBjAiHlqqRiVk=
 gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c/go.mod h1:JHkPIbrfpd72SG/EVd6muEfDQjcINNoR0C8j2r3qZ4Q=
 gopkg.in/h2non/gock.v1 v1.1.2 h1:jBbHXgGBK/AoPVfJh5x4r/WxIrElvbLel8TCZkkZJoY=
+gopkg.in/h2non/gock.v1 v1.1.2/go.mod h1:n7UGz/ckNChHiK05rDoiC4MYSunEC/lyaUm2WWaDva0=
 gopkg.in/inf.v0 v0.9.1 h1:73M5CoZyi3ZLMOyDlQh031Cx6N9NDJ2Vvfl76EDAgDc=
 gopkg.in/inf.v0 v0.9.1/go.mod h1:cWUDdTG/fYaXco+Dcufb5Vnc6Gp2YChqWtbxRZE0mXw=
 gopkg.in/yaml.v2 v2.2.8/go.mod h1:hI93XBmqTisBFMUTm0b8Fm+jr3Dg1NNxqwp+5A1VGuI=
